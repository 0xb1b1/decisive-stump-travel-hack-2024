use std::time::Duration;
use async_std::task;
use rsmq_async::RsmqConnection;

mod connections;
mod models;
mod enums;
mod tasks;

use crate::enums::rsmq::RsmqDsQueue;
use crate::enums::worker::TaskType;


#[tokio::main]
async fn main() {
    env_logger::init();

    log::info!("Creating RSMQ pool...");
    // RSMQ uses a built-in connection pool
    let mut rsmq_pool = connections::rsmq::get_pool().await.unwrap();
    log::info!("Created RSMQ pool.");
    log::debug!("RSMQ queues list: {:?}", rsmq_pool.list_queues().await.unwrap());

    log::info!("Connecting to Minio...");
    let bucket_images = connections::s3::get_bucket(Some("images")).await.unwrap();
    let bucket_images_compressed = connections::s3::get_bucket(Some("images-comp")).await.unwrap();
    let bucket_images_thumbs = connections::s3::get_bucket(Some("images-thumbs")).await.unwrap();
    log::info!("Connected to Minio.");

    let mut process_failed_queue_counter: u8 = 0;
    loop {
        log::debug!("Checking RSMQ...");

        // Set queue name to check
        let queue_name: RsmqDsQueue;
        if process_failed_queue_counter > 4 {
            queue_name = RsmqDsQueue::BackendWorkerFailed;
            process_failed_queue_counter = 0;
        } else {
            queue_name = RsmqDsQueue::BackendWorker;
            process_failed_queue_counter += 1;
        }

        log::debug!("Working in task queue: {}", queue_name.as_str());

        let message = match rsmq_pool.pop_message::<String>(
            queue_name.as_str()
        ).await {
            Ok(msg) => msg,
            Err(err) => {
                log::error!("Failed to receive message: {}", err);
                task::sleep(Duration::from_secs(10)).await;
                continue;
            }
        };

        if let Some(msg) = message {
            // Serialize message
            let task: TaskType = match serde_json::from_str(&msg.message) {
                Ok(task) => task,
                Err(err) => {
                    log::error!("Failed to parse message: {}", err);
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
                        &mut rsmq_pool
                    ).await {
                        Ok(_) => {
                            log::info!("Compressed image.");
                        },
                        Err(err) => {
                            log::error!("Failed to compress image: {}", err);
                            continue;
                        }
                    }
                },
            }
        }

        task::sleep(Duration::from_secs(3)).await;
    }

}
