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

    loop {
        log::debug!("Checking RSMQ...");
        let message = match rsmq_pool.pop_message::<String>(
            RsmqDsQueue::BackendWorker.as_str()
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
                TaskType::CompressImage { filename } => {
                    log::info!("Downloading image: {}", filename);
                    let original_file = match tasks::utils::files::tmp::download_s3_file(
                        &bucket_images,
                        &filename
                    ).await {
                        Ok(data) => {
                            log::debug!("Downloaded image from S3");
                            data
                        },
                        Err(err) => {
                            log::error!("Failed to download image from S3: {}", err);
                            continue;  // TODO: Send back to queue?
                        }
                    };

                    log::info!("Compressing image (comp bucket): {}", filename);
                    // Check file size (if it's already less than 2MB, just copy it to comp bucket)
                    let original_file_length = original_file.as_slice().len() as u64;
                    log::debug!("Original file length: {}", original_file_length);
                    if original_file_length < 2_000_000 {
                        log::info!("File is already compressed, copying to comp bucket.");
                        match bucket_images_compressed.put_object(&filename, original_file.as_slice()).await {
                            Ok(_) => {
                                log::info!("Copied image to comp bucket.");
                            },
                            Err(err) => {
                                log::error!("Failed to copy image to comp bucket: {}", err);
                                continue;  // TODO: Send back to queue?
                            }
                        }
                    } else {
                        log::info!("File is not small enough for comp bucket, compressing it.");
                    }

                    match tasks::compress::compress_image(
                        &original_file,
                        &filename,
                        &bucket_images_compressed,
                        80.,
                        0.8
                    ).await {
                        Ok(image_info) => {
                            log::info!("Compressed image (comp bucket): {:?}", image_info);
                        },
                        Err(err) => {
                            log::error!("Failed to compress image (comp bucket), sending back to queue: {}", err);
                            // Send with delay
                            match rsmq_pool.send_message(
                                RsmqDsQueue::BackendWorker.as_str(),
                                msg.message.clone(),
                                Some(Duration::from_secs(10))
                            ).await {
                                Ok(_) => {
                                    log::info!("Sent message back to queue (comp bucket).");
                                },
                                Err(err) => {
                                    log::error!("Failed to send message back to queue (comp bucket): {}", err);
                                }
                            }
                        }
                    }

                    log::info!("Compressing image (thumbs bucket): {}", filename);
                    match tasks::compress::compress_image(
                        &original_file,
                        &filename,
                        &bucket_images_thumbs,
                        60.,
                        0.4
                    ).await {
                        Ok(image_info) => {
                            log::info!("Compressed image (thumbs bucket): {:?}", image_info);
                        },
                        Err(err) => {
                            log::error!("Failed to compress image (thumbs bucket), sending back to queue: {}", err);
                            // Send with delay
                            match rsmq_pool.send_message(
                                RsmqDsQueue::BackendWorker.as_str(),
                                msg.message.clone(),
                                Some(Duration::from_secs(10))
                            ).await {
                                Ok(_) => {
                                    log::info!("Sent message back to queue (thumbs bucket).");
                                },
                                Err(err) => {
                                    log::error!("Failed to send message back to queue (thumbs bucket): {}", err);
                                }
                            }
                        }
                    }
                }
            }
        }

        task::sleep(Duration::from_secs(3)).await;
    }

}
