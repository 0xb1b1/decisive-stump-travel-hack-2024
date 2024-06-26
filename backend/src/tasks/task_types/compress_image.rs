// use bb8::Pool;
// use bb8_redis::RedisConnectionManager;
use rocket::serde::json;
use rsmq_async::{PooledRsmq, RsmqConnection};
use s3::Bucket;
use serde::Serialize;

use crate::enums::rsmq::RsmqDsQueue; // worker::TaskType

// use crate::tasks::task_types::utils::queues::send_to_error_queue;

mod job;

// Move the following into a specialized module (hence pub)
#[derive(Serialize, Debug)]
pub struct MlUploadAnalyzeMessage {
    pub filename: String,
    pub force: bool,
}

async fn send_ml_upload_task(
    filename: &str,
    rsmq_pool: &mut PooledRsmq,
    force: bool,
) -> Result<(), String> {
    // This task is meant for ML to recognize possible tags and shove then into a redis key with format
    // images:upload:ready-{filename}. After that the frontend eventually gets the tags and proceeds with
    // finalizing the upload.

    let message = MlUploadAnalyzeMessage {
        filename: filename.to_string(),
        force: force,
    };

    // Send task to ML neighbors using queue
    let task = RsmqDsQueue::UploadAnalyzeMl;
    match rsmq_pool
        .send_message(&task.as_str(), json::to_string(&message).unwrap(), None)
        .await
    {
        Ok(_) => {
            log::info!("Sent message to RSMQ queue: {}", task.as_str());
            Ok(())
        }
        Err(err) => {
            log::error!(
                "Failed to send message to RSMQ queue: {}: {}",
                task.as_str(),
                err
            );
            Err("Failed to send message to RSMQ queue.".into())
        }
    }
}

pub async fn compress_normal(
    filename: &str,
    bucket_images: &Bucket,
    bucket_images_compressed: &Bucket,
    bucket_images_thumbs: &Bucket,
    rsmq_pool: &mut PooledRsmq,
    force: bool,
) -> Result<(), String> {
    log::info!("Downloading image: {}", filename);
    let original_file =
        match crate::tasks::utils::files::tmp::download_s3_file(&bucket_images, &filename).await {
            Ok(data) => {
                log::debug!("Downloaded image from S3");
                data
            }
            Err(err) => {
                log::error!("Failed to download image from S3: {}", err);
                // let _ = send_to_error_queue(
                //     &TaskType::CompressImage {
                //         filename: filename.to_string(),
                //     },
                //     rsmq_pool,
                // )
                // .await;
                // TODO! Implement failure key setting
                return Err("Failed to download image from S3.".into());
            }
        };

    log::info!("Compressing image (comp bucket): {}", filename);

    // Check file size (if it's already less than 2MB, just copy it to comp bucket)
    let original_file_size = original_file.as_slice().len() as u64;
    log::debug!("Original file length: {}", original_file_size);

    // Create compression params based on file size
    let compression_params_comp: Option<job::CompressionParams>;
    let compression_params_thumb: Option<job::CompressionParams>;
    if original_file_size < 2_000_000 {
        log::info!("File is already small enough, copying to comp bucket (lt 2MB).");
        compression_params_comp = None;
        compression_params_thumb = Some(job::CompressionParams {
            quality: 50.,
            size_ratio: 0.6,
        })
    } else if original_file_size < 5_000_000 {
        log::info!("File is not small enough for comp bucket, compressing it (lt 5MB).");
        compression_params_comp = Some(job::CompressionParams {
            quality: 60.,
            size_ratio: 0.6,
        });
        compression_params_thumb = Some(job::CompressionParams {
            quality: 40.,
            size_ratio: 0.4,
        });
    } else if original_file_size < 10_000_000 {
        log::info!("File is not small enough for comp bucket, compressing it (lt 15MB).");
        compression_params_comp = Some(job::CompressionParams {
            quality: 55.,
            size_ratio: 0.4,
        });
        compression_params_thumb = Some(job::CompressionParams {
            quality: 35.,
            size_ratio: 0.4,
        });
    } else if original_file_size < 15_000_000 {
        log::info!("File is not small enough for comp bucket, compressing it (lt 15MB).");
        compression_params_comp = Some(job::CompressionParams {
            quality: 52.,
            size_ratio: 0.4,
        });
        compression_params_thumb = Some(job::CompressionParams {
            quality: 30.,
            size_ratio: 0.3,
        });
    } else {
        log::info!("File is not small enough for comp bucket, compressing it (gt 15MB).");
        compression_params_comp = Some(job::CompressionParams {
            quality: 50.,
            size_ratio: 0.3,
        });
        compression_params_thumb = Some(job::CompressionParams {
            quality: 27.,
            size_ratio: 0.3,
        });
    }

    let compressed_result: Result<(), ()>;
    let thumb_result: Result<(), ()>;
    // Compress image
    if let Some(params) = compression_params_comp {
        compressed_result =
            match job::compress(&original_file, &filename, &bucket_images_compressed, params).await
            {
                Ok(_) => {
                    log::info!("Compressed image (comp bucket): {:?}", filename);
                    Ok(())
                }
                Err(err) => {
                    log::error!("Failed to compress image (comp bucket), failing: {}", err);
                    // let _ = send_to_error_queue(
                    //     &TaskType::CompressImage {
                    //         filename: filename.to_string(),
                    //     },
                    //     rsmq_pool,
                    // )
                    // .await;
                    // TODO! Implement failure key setting
                    Err(())
                }
            }
    } else {
        log::info!("File is already small enough, copying to comp bucket.");
        compressed_result = match bucket_images_compressed
            .put_object(&filename, original_file.as_slice())
            .await
        {
            Ok(_) => {
                log::info!("Copied image to comp bucket.");
                Ok(())
            }
            Err(err) => {
                log::error!("Failed to copy image to comp bucket: {}", err);
                // let _ = send_to_error_queue(
                //     &TaskType::CompressImage {
                //         filename: filename.to_string(),
                //     },
                //     rsmq_pool,
                // )
                // .await;
                // TODO! Implement failure key setting
                Err(())
            }
        }
    };

    // comp_filename should always end in .jpg (since we're compressing to jpg)
    // Remove the previous extension if it's not .jpg
    let comp_filename: String;
    let filename_parts = filename.split('.').collect::<Vec<&str>>();
    if filename_parts.len() == 2 {
        comp_filename = format!("{}.jpg", filename_parts[0]);
    } else {
        // Panicking here to draw more attention to the issue
        panic!(
            "Filename should only contain two sections divided by a dot! ({}).",
            filename
        );
    }

    // Send upload task for ML here since it only uses the comp bucket
    match send_ml_upload_task(&filename, rsmq_pool, force).await {
        Ok(_) => {
            log::info!("Sent ML Upload task for file {}", &comp_filename);
        }
        Err(err) => {
            log::error!(
                "Failed to send upload task to ML; sending to error queue: {}",
                err
            );
            // let _ = send_to_error_queue(
            //     &TaskType::CompressImage {
            //         filename: comp_filename,
            //     },
            //     rsmq_pool,
            // )
            // .await;
            // TODO! Implement failure key setting
        }
    }

    if let Some(params) = compression_params_thumb {
        thumb_result =
            match job::compress(&original_file, &filename, &bucket_images_thumbs, params).await {
                Ok(_) => {
                    log::info!("Compressed image (thumb bucket): {:?}", filename);
                    Ok(())
                }
                Err(err) => {
                    log::error!("Failed to compress image (thumb bucket), failing: {}", err);
                    // let _ = send_to_error_queue(
                    //     &TaskType::CompressImage {
                    //         filename: filename.to_string(),
                    //     },
                    //     rsmq_pool,
                    // )
                    // .await;
                    // TODO! Implement failure key setting
                    Err(())
                }
            }
    } else {
        log::info!("File is already small enough, copying to thumb bucket.");
        thumb_result = match bucket_images_thumbs
            .put_object(&filename, original_file.as_slice())
            .await
        {
            Ok(_) => {
                log::info!("Copied image to thumb bucket.");
                Ok(())
            }
            Err(err) => {
                log::error!(
                    "Failed to copy image to thumb bucket: {}, setting failure key...",
                    err
                );
                // TODO!: Implement failure key setting
                Err(())
            }
        }
    };

    if compressed_result.is_ok() && thumb_result.is_ok() {
        Ok(())
    } else {
        Err("Failed to compress image.".into())
    }
}
