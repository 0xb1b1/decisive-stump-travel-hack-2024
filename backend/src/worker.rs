use std::time::Duration;
use async_std::task;
use redis::RedisError;
use rsmq_async::RsmqConnection;

mod connections;
mod models;
mod enums;
mod tasks;
mod locks;
mod utils;

use crate::enums::rsmq::RsmqDsQueue;
use crate::enums::worker::TaskType;
use crate::models::http::images::ImageInfoGallery;
use crate::models::http::main_page::{GalleryResponse, RedisGalleryStore};
use crate::connections::urls::get_urls;


#[tokio::main]
async fn main() {
    env_logger::init();

    log::info!("Creating RSMQ pool...");
    // RSMQ uses a built-in connection pool
    let mut rsmq_pool = connections::rsmq::get_pool().await.unwrap();
    log::info!("Created RSMQ pool.");
    log::debug!("RSMQ queues list: {:?}", rsmq_pool.list_queues().await.unwrap());

    log::info!("Creating Redis pool...");
    let redis_pool = connections::redis::get_pool().await.unwrap();
    log::info!("Created Redis pool.");

    log::info!("Connecting to Minio...");
    let bucket_images = connections::s3::get_bucket(Some("images")).await.unwrap();
    let bucket_images_compressed = connections::s3::get_bucket(Some("images-comp")).await.unwrap();
    let bucket_images_thumbs = connections::s3::get_bucket(Some("images-thumbs")).await.unwrap();
    log::info!("Connected to Minio.");

    log::info!("Gettings DS URLs from environment...");
    let ds_urls = get_urls();
    log::info!("DS URLs: {:?}", ds_urls);

    let mut worker_queue_counter: u8 = 1;  // <255
    loop {
        task::sleep(Duration::from_secs(3)).await;
        log::debug!("Checking conditions...");

        // Set queue name to check
        let scheduled_queue: Option<RsmqDsQueue>;
        let check_main_gallery: bool;  // Skips queue processing

        log::debug!("Worker queue counter: {}", worker_queue_counter);
        if worker_queue_counter % 11 == 0 {
            match locks::worker_gallery::check(&redis_pool).await {
                Ok(is_locked) => {
                    if is_locked {
                        log::debug!("Main gallery is locked. Processing BackendWorker queue.");
                        scheduled_queue = Some(RsmqDsQueue::BackendWorker);
                        check_main_gallery = false;
                    } else {
                        log::debug!("Main gallery is not locked. Checking main gallery.");
                        scheduled_queue = None;
                        check_main_gallery = true;
                    }
                },
                Err(err) => {
                    log::error!("Failed to check main gallery lock, processing queue: {}", err);
                    scheduled_queue = Some(RsmqDsQueue::BackendWorker);
                    check_main_gallery = false;
                }
            };
        } else if worker_queue_counter % 4 == 0 {
            log::debug!("Checking BackendWorkerFailed queue.");
            scheduled_queue = Some(RsmqDsQueue::BackendWorkerFailed);
            check_main_gallery = false;
        } else {
            log::debug!("Processing BackendWorker queue.");
            scheduled_queue = Some(RsmqDsQueue::BackendWorker);
            check_main_gallery = false;
        }

        // Reset counter on 253
        if worker_queue_counter >= 253 {
            worker_queue_counter = 0;
        }

        if check_main_gallery {
            log::debug!("Checking main gallery cache...");

            log::debug!("Locking main gallery...");
            match locks::worker_gallery::lock(&redis_pool).await {
                Ok(_) => {
                    log::debug!("Main gallery locked.");
                },
                Err(err) => {
                    log::error!("Failed to lock main gallery, failing: {}", err);
                    worker_queue_counter += 1;
                    continue;
                }
            }

            let mut ml_generated_gallery: Option<String> = match redis::cmd("GET")
                .arg("images:collections:main")
                .query_async(&mut *redis_pool.get().await.unwrap())
                .await {
                    Ok(gallery) => gallery,
                    Err(err) => {
                        log::error!("Failed to get main gallery from Redis, failing: {}", err);
                        worker_queue_counter += 1;
                        continue;
                    }
                };

            if let Some(gallery) = ml_generated_gallery {
                log::debug!("Main gallery found in Redis: {}", gallery);
            } else {
                log::debug!("Main gallery not found in Redis.");
                log::warn!("Asking ML to repopulate the main gallery.");
                match reqwest::get(
                    format!("{}/main/{}", ds_urls.ml_neighbors_fast.as_str(), 100)  // TODO: Set via ENV
                ).await {
                    Ok(_) => {
                        log::info!("Request to ML successful. Re-running this task in 3 seconds.");
                        task::sleep(Duration::from_secs(3)).await;
                        continue;
                    },
                    Err(err) => {
                        log::error!("Failed to request ML, failing: {}", err);
                        worker_queue_counter += 1;
                        continue;
                    }
                }
            }

        let gallery: Result<String, RedisError> = redis::cmd("GET")
        .arg("images:collections:main")
        .query_async(&mut *redis_pool.get().await.unwrap())
        .await;

        let gallery_redis: RedisGalleryStore = match gallery {
            Ok(gallery) => {
                log::debug!("Generating full collection using S3 presigned links.");
                let gallery_redis: RedisGalleryStore = match serde_json::from_str::<RedisGalleryStore>(&gallery) {
                    Ok(gallery) => {
                        let mut gallery_full: Vec<ImageInfoGallery> = Vec::new();
                        for image in gallery.images {
                            let presigned_url = utils::s3::images::get_presigned_url(
                                &image.filename,
                                &bucket_images_thumbs,
                                21_600  // 6 hours
                            ).await.unwrap();
                            gallery_full.push(
                                ImageInfoGallery {
                                    filename: image.filename,
                                    s3_presigned_url: Some(presigned_url),
                                    label: image.label,
                                    tags: image.tags,
                                    error: None
                                }
                            );
                        }
                        RedisGalleryStore {
                            images: gallery_full
                        }
                    },
                    Err(e) => {
                        log::error!("Failed to parse gallery from Redis: {}", e);
                        worker_queue_counter += 1;
                        continue;
                    }
                };
                gallery_redis
            },
            Err(e) => {
                log::error!("Failed to get gallery from Redis: {}", e);
                worker_queue_counter += 1;
                continue;
            }
        };

        log::debug!("Sending full collection to Redis.");
        match redis::cmd("SET")
            .arg("images:collections:main:full")
            .arg(serde_json::to_string(&gallery_redis).unwrap())
            .arg("EX")
            .arg(60 * 30)
            .query_async::<_, ()>(&mut *redis_pool.get().await.unwrap())
            .await {
                Ok(_) => {
                    log::info!("Full collection sent to Redis.");
                },
                Err(e) => {
                    log::error!("Failed to send full collection to Redis: {}", e);
                    worker_queue_counter += 1;
                    continue;
                }
            }

            worker_queue_counter += 1;
            continue;
        }

        // Check for messages in queue
        if let Some(queue) = scheduled_queue {
            log::debug!("Working in task queue: {}", queue.as_str());
            let message = match rsmq_pool.pop_message::<String>(
                queue.as_str()
            ).await {
                Ok(msg) => msg,
                Err(err) => {
                    log::error!("Failed to receive message: {}", err);
                    task::sleep(Duration::from_secs(10)).await;
                    worker_queue_counter += 1;
                    continue;
                }
            };

            if let Some(msg) = message {
                // Serialize message
                let task: TaskType = match serde_json::from_str(&msg.message) {
                    Ok(task) => task,
                    Err(err) => {
                        log::error!("Failed to parse message: {}", err);
                        worker_queue_counter += 1;
                        continue;
                    }
                };
                log::info!("Received a new message (task): {}", serde_json::to_string(&task).unwrap());

                // Process task
                match task {
                    TaskType::DeleteImage { filename } => {
                        log::info!("Received DeleteImage task: {}", filename);
                        match tasks::task_types::delete_image::delete_from_all_buckets(
                            &filename,
                            &bucket_images,
                            &bucket_images_compressed,
                            &bucket_images_thumbs,
                            &mut rsmq_pool
                        ).await {
                            Ok(_) => {
                                log::info!("Deleted image from all buckets.");
                            },
                            Err(err) => {
                                log::error!("Failed to delete image from all buckets: {}", err);
                                worker_queue_counter += 1;
                                continue;
                            }
                        }

                    }
                    TaskType::CompressImage { filename } => {
                        log::info!("Received CompressImage task: {}", filename);

                        match tasks::task_types::compress_image::compress_normal(
                            &filename,
                            &bucket_images,
                            &bucket_images_compressed,
                            &bucket_images_thumbs,
                            &redis_pool,
                            &mut rsmq_pool
                        ).await {
                            Ok(_) => {
                                log::info!("Compressed image.");
                            },
                            Err(err) => {
                                log::error!("Failed to compress image: {}", err);
                                worker_queue_counter += 1;
                                continue;
                            }
                        }
                    },
                }
            }
        }

        worker_queue_counter += 1;
    }
}
