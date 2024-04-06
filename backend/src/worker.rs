use async_std::task;
use ds_travel_hack_2024::models::http::images::S3PresignedUrls;
use ds_travel_hack_2024::utils::redis::galleries;
use redis::RedisError;
use rsmq_async::RsmqConnection;
use std::time::Duration;

mod config;

use ds_travel_hack_2024::connections;
use ds_travel_hack_2024::enums::{rsmq::RsmqDsQueue, worker::TaskType};
use ds_travel_hack_2024::locks;
use ds_travel_hack_2024::models::http::{images::ImageInfoGallery, main_page::RedisGalleryStore};

#[tokio::main]
async fn main() {
    env_logger::init();

    log::info!("Creating RSMQ pool...");
    // RSMQ uses a built-in connection pool
    let mut rsmq_pool = connections::rsmq::get_pool().await.unwrap();
    log::info!("Created RSMQ pool.");
    log::debug!(
        "RSMQ queues list: {:?}",
        rsmq_pool.list_queues().await.unwrap()
    );

    log::info!("Creating Redis pool...");
    let redis_pool = connections::redis::get_pool().await.unwrap();
    log::info!("Created Redis pool.");

    log::info!("Connecting to Minio...");
    let bucket_images = connections::s3::get_bucket(Some("images")).await.unwrap();
    let bucket_images_compressed = connections::s3::get_bucket(Some("images-comp"))
        .await
        .unwrap();
    let bucket_images_thumbs = connections::s3::get_bucket(Some("images-thumbs"))
        .await
        .unwrap();
    log::info!("Connected to Minio.");

    log::info!("Creating configuration...");
    let config = config::get_config().unwrap();
    log::info!("Created configuration: {:?}", config);

    let mut worker_queue_counter: u8 = 1; // <255
    loop {
        task::sleep(Duration::from_secs(3)).await;
        log::debug!("Checking conditions...");

        // Set queue name to check
        let scheduled_queue: Option<RsmqDsQueue>;
        let requeue_killed_jobs: bool; // Skips queue processing.
                                       // ^ These are set as Redis keys before the worker starts processing a message.
                                       // ^ If the worker is killed, the keys remain set for them to be processed by another worker.
                                       // ^ These differ from failed jobs in that they are not requeued since the worker is killed.
        let check_main_gallery: bool; // Skips queue processing; mutates if ML generated gallery is not old enough.

        log::debug!("Worker queue counter: {}", worker_queue_counter);
        if worker_queue_counter % 11 == 0 {
            match locks::worker_gallery::check(&redis_pool).await {
                Ok(is_locked) => {
                    if is_locked {
                        log::debug!("Main gallery is locked. Processing BackendWorker queue.");
                        scheduled_queue = Some(RsmqDsQueue::BackendWorker);
                        check_main_gallery = false;
                        requeue_killed_jobs = false;
                    } else {
                        log::debug!("Main gallery is not locked. Checking main gallery.");
                        scheduled_queue = None;
                        check_main_gallery = true;
                        requeue_killed_jobs = false;
                    }
                }
                Err(err) => {
                    log::error!(
                        "Failed to check main gallery lock, processing queue: {}",
                        err
                    );
                    scheduled_queue = Some(RsmqDsQueue::BackendWorker);
                    check_main_gallery = false;
                    requeue_killed_jobs = false;
                }
            };
        } else if worker_queue_counter % 4 == 0 {
            log::debug!("Checking BackendWorkerFailed queue.");
            scheduled_queue = Some(RsmqDsQueue::BackendWorkerFailed);
            check_main_gallery = false;
            requeue_killed_jobs = false;
        } else if worker_queue_counter % 17 == 0 {
            log::debug!("Processing keys set by failed workers.");
            scheduled_queue = None;
            check_main_gallery = false;
            requeue_killed_jobs = true;
        } else {
            log::debug!("Processing BackendWorker queue.");
            scheduled_queue = Some(RsmqDsQueue::BackendWorker);
            check_main_gallery = false;
            requeue_killed_jobs = false;
        }

        // Reset counter on 253
        if worker_queue_counter >= 253 {
            worker_queue_counter = 0;
        }

        if requeue_killed_jobs {
            // TODO: Test this block
            log::debug!("Processing keys set by failed workers...");
            let keys: Vec<String> = match redis::cmd("KEYS")
                .arg("worker:running-task:*")
                .query_async(&mut *redis_pool.get().await.unwrap())
                .await
            {
                Ok(keys) => keys,
                Err(err) => {
                    log::error!("Failed to get keys set by failed workers: {}", err);
                    worker_queue_counter += 1;
                    continue;
                }
            };

            log::debug!("Keys set by failed workers: {:?}", keys);

            for key in keys {
                // If task is less than 10 minutes old, skip (separate key by : and get the last element)
                let key_split: Vec<&str> = key.split(":").collect();
                let entry_timestamp: i64 = key_split[key_split.len() - 1].parse().unwrap();

                if chrono::Utc::now().timestamp() - entry_timestamp < 600 {
                    log::info!("Task is less than 10 minutes old, skipping.");
                    continue;
                }

                let task: String = match redis::cmd("GET")
                    .arg(&key)
                    .query_async(&mut *redis_pool.get().await.unwrap())
                    .await
                {
                    Ok(task) => task,
                    Err(err) => {
                        log::error!("Failed to get task set by failed worker: {}", err);
                        worker_queue_counter += 1;
                        continue;
                    }
                };

                let task: TaskType = match serde_json::from_str(&task) {
                    Ok(task) => task,
                    Err(err) => {
                        log::error!("Failed to parse task set by failed worker: {}", err);
                        worker_queue_counter += 1;
                        continue;
                    }
                };

                log::info!(
                    "Requeuing task from failed worker: {}",
                    serde_json::to_string(&task).unwrap()
                );

                match rsmq_pool
                    .send_message(
                        RsmqDsQueue::BackendWorkerFailed.as_str(),
                        serde_json::to_string(&task).unwrap(),
                        None,
                    )
                    .await
                {
                    Ok(_) => {
                        log::info!("Requeued task from failed worker.");
                    }
                    Err(err) => {
                        log::error!("Failed to requeue task from failed worker: {}", err);
                        worker_queue_counter += 1;
                        continue;
                    }
                };

                match redis::cmd("DEL")
                    .arg(&key)
                    .query_async::<_, Option<String>>(&mut *redis_pool.get().await.unwrap())
                    .await
                {
                    Ok(_) => {
                        log::info!("Deleted key set by failed worker.");
                    }
                    Err(err) => {
                        log::error!("Failed to delete key set by failed worker: {}", err);
                        worker_queue_counter += 1;
                        continue;
                    }
                }
            }
        }

        let gallery_ttl: Option<u64>;
        if check_main_gallery {
            log::debug!("Checking if main gallery exists...");
            let gallery_exists: bool = galleries::ml_gallery_exists(&redis_pool).await;

            if gallery_exists {
                log::debug!("Gallery exists, checking main gallery TTL...");
                // Get TTL of ML generated gallery
                gallery_ttl = match redis::cmd("TTL")
                    .arg("images:collections:main")
                    .query_async(&mut *redis_pool.get().await.unwrap())
                    .await
                {
                    Ok(ttl) => ttl,
                    Err(err) => {
                        log::error!("Failed to get TTL of main gallery: {}", err);
                        worker_queue_counter += 1;
                        continue;
                    }
                };
            } else {
                gallery_ttl = None;
            }

            log::debug!("Main gallery TTL: {:?}", gallery_ttl);

            if gallery_ttl > Some(750) {
                log::info!("Main gallery is not old enough, skipping.");
                worker_queue_counter += 1;
                continue;
            }
        }

        if check_main_gallery {
            log::debug!("Checking main gallery cache...");

            log::debug!("Locking main gallery...");
            match locks::worker_gallery::lock(&redis_pool).await {
                Ok(_) => {
                    log::debug!("Main gallery locked.");
                }
                Err(err) => {
                    log::error!("Failed to lock main gallery, failing: {}", err);
                    worker_queue_counter += 1;
                    continue;
                }
            }

            let ml_generated_gallery: Option<String> = match redis::cmd("GET")
                .arg("images:collections:main")
                .query_async(&mut *redis_pool.get().await.unwrap())
                .await
            {
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
                match reqwest::get(format!("{}/main/{}", config.svc_ml_fast, 999)).await {
                    Ok(_) => {
                        log::info!("Request to ML successful. Re-running this task in 3 seconds.");
                        task::sleep(Duration::from_secs(3)).await;
                        continue;
                    }
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
                    let gallery_redis: RedisGalleryStore =
                        match serde_json::from_str::<RedisGalleryStore>(&gallery) {
                            Ok(gallery) => {
                                let mut gallery_full: Vec<ImageInfoGallery> = Vec::new();
                                for image in gallery.images {
                                    let presigned_url =
                                        ds_travel_hack_2024::utils::s3::images::get_presigned_url(
                                            &image.filename,
                                            &bucket_images,
                                            10_800, // 3 hours
                                        )
                                        .await;
                                    let presigned_url_comp =
                                        ds_travel_hack_2024::utils::s3::images::get_presigned_url(
                                            &image.filename,
                                            &bucket_images_compressed,
                                            10_800, // 3 hours
                                        )
                                        .await;
                                    let presigned_url_thumb =
                                        ds_travel_hack_2024::utils::s3::images::get_presigned_url(
                                            &image.filename,
                                            &bucket_images_thumbs,
                                            10_800, // 3 hours
                                        )
                                        .await;
                                    gallery_full.push(ImageInfoGallery {
                                        filename: image.filename,
                                        s3_presigned_urls: Some(S3PresignedUrls {
                                            normal: presigned_url,
                                            comp: presigned_url_comp,
                                            thumb: presigned_url_thumb,
                                        }),
                                        label: image.label,
                                        tags: image.tags,
                                        error: None,
                                    });
                                }
                                RedisGalleryStore {
                                    images: gallery_full,
                                    ..RedisGalleryStore::new()
                                }
                            }
                            Err(e) => {
                                log::error!("Failed to parse gallery from Redis: {}", e);
                                worker_queue_counter += 1;
                                continue;
                            }
                        };
                    gallery_redis
                }
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
                .await
            {
                Ok(_) => {
                    log::info!("Full collection sent to Redis.");
                }
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
            let message = match rsmq_pool.pop_message::<String>(queue.as_str()).await {
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
                log::info!(
                    "Received a new message (task): {}",
                    serde_json::to_string(&task).unwrap()
                );

                // Set task key to Redis
                let unix_timestamp = chrono::Utc::now().timestamp();
                let task_key = format!("worker:running-task:{}:{}", task.as_str(), unix_timestamp);
                match redis::cmd("SET")
                    .arg(&task_key)
                    .arg(serde_json::to_string(&task).unwrap())
                    .arg("EX")
                    .arg(60 * 60 * 24)
                    .query_async::<_, ()>(&mut *redis_pool.get().await.unwrap())
                    .await
                {
                    Ok(_) => {
                        log::info!("Set task key to Redis.");
                    }
                    Err(err) => {
                        log::error!("Failed to set task key to Redis: {}", err);
                        worker_queue_counter += 1;
                        continue;
                    }
                }

                // Process task
                match task {
                    TaskType::GenS3PresignedUrls { ref filename, expiry_secs } => {
                        log::info!(
                            "Received GenS3PresignedUrls task: {} with expiry_secs: {}",
                            filename,
                            expiry_secs
                        );
                        let presigned_url =
                        ds_travel_hack_2024::utils::s3::images::get_presigned_url(
                            &filename,
                            &bucket_images,
                            expiry_secs,
                        ).await;
                        let presigned_url_comp =
                        ds_travel_hack_2024::utils::s3::images::get_presigned_url(
                            &filename,
                            &bucket_images_compressed,
                            expiry_secs,
                        ).await;
                        let presigned_url_thumb =
                        ds_travel_hack_2024::utils::s3::images::get_presigned_url(
                            &filename,
                            &bucket_images_thumbs,
                            expiry_secs,
                        ).await;

                        let s3_presigned_urls = S3PresignedUrls {
                            normal: presigned_url,
                            comp: presigned_url_comp,
                            thumb: presigned_url_thumb,
                        };

                        // Send to Redis
                        let _ = match redis::cmd("SET")
                            .arg(format!("images:presigned_urls:{}", filename))
                            .arg(serde_json::to_string(&s3_presigned_urls).unwrap())
                            .arg("EX")
                            .arg(expiry_secs - 5)  // To prevent expired presigned URLs being sent to clients
                            .query_async::<_, ()>(&mut *redis_pool.get().await.unwrap())
                            .await
                        {
                            Ok(_) => {
                                log::info!("Sent presigned URLs to Redis.");
                            }
                            Err(err) => {
                                log::error!("Failed to send presigned URLs to Redis: {}", err);
                                // Send to failed queue
                                match rsmq_pool
                                    .send_message(
                                        RsmqDsQueue::BackendWorkerFailed.as_str(),
                                        serde_json::to_string(&task).unwrap(),
                                        None,
                                    )
                                    .await
                                {
                                    Ok(_) => {
                                        log::info!("Sent task to failed queue.");
                                    }
                                    Err(err) => {
                                        log::error!("Failed to send task to failed queue: {}", err);
                                        worker_queue_counter += 1;
                                        continue;
                                    }
                                }
                                worker_queue_counter += 1;
                                continue;
                            }
                        };
                    },
                    TaskType::DeleteImage { filename } => {
                        log::info!("Received DeleteImage task: {}", filename);
                        match ds_travel_hack_2024::tasks::task_types::delete_image::delete_from_all_buckets(
                            &filename,
                            &bucket_images,
                            &bucket_images_compressed,
                            &bucket_images_thumbs,
                            &mut rsmq_pool,
                        )
                        .await
                        {
                            Ok(_) => {
                                log::info!("Deleted image from all buckets.");
                            }
                            Err(err) => {
                                log::error!("Failed to delete image from all buckets: {}", err);
                                worker_queue_counter += 1;
                                continue;
                            }
                        }
                    }
                    TaskType::CompressImage { filename } => {
                        log::info!("Received CompressImage task: {}", filename);

                        match ds_travel_hack_2024::tasks::task_types::compress_image::compress_normal(
                            &filename,
                            &bucket_images,
                            &bucket_images_compressed,
                            &bucket_images_thumbs,
                            &mut rsmq_pool,
                        )
                        .await
                        {
                            Ok(_) => {
                                log::info!("Compressed image.");
                            }
                            Err(err) => {
                                log::error!("Failed to compress image: {}", err);
                                worker_queue_counter += 1;
                                continue;
                            }
                        }
                    }
                }
                // Remove task key from Redis
               match redis::cmd("DEL")
                    .arg(&task_key)
                    .query_async::<_, ()>(&mut *redis_pool.get().await.unwrap())
                    .await
                {
                    Ok(_) => {
                        log::info!("Deleted task key from Redis.");
                    }
                    Err(err) => {
                        log::error!("Failed to delete task key from Redis: {}", err);
                        worker_queue_counter += 1;
                        continue;
                    }
                }
            }
        }

        worker_queue_counter += 1;
    }
}
