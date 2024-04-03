use bb8::Pool;
use bb8_redis::RedisConnectionManager;
use rocket::serde::json;
use rsmq_async::{RsmqConnection, PooledRsmq};
use s3::Bucket;
use serde::Serialize;

use crate::enums::rsmq::RsmqDsQueue;
use crate::enums::worker::TaskType;
use crate::models::http::images::ImageInfo;
use crate::tasks::task_types::utils::queues::send_to_error_queue;

mod job;

// Move the following into a specialized module (hence pub)
#[derive(Serialize, Debug)]
pub struct MlUploadAnalyzeMessage {
    pub filename: String,
}

async fn send_ml_upload_task(
    filename: &str,
    rsmq_pool: &mut PooledRsmq
) -> Result<(), String> {
    // This task is meant for ML to recognize possible tags and shove then into a redis key with format
    // images:upload:ready-{filename}. After that the frontend eventually gets the tags and proceeds with
    // finalizing the upload.

    // The following commented code is not needed here,
    // but it will be used in the finalizing stage of the upload (after frontend query.)
    // // Get image info from Redis
    // let mut redis_conn = match redis_pool.get().await {
    //     Ok(conn) => conn,
    //     Err(err) => {
    //         log::error!("Failed to get Redis connection: {}", err);
    //         return Err("Failed to get Redis connection.".into());
    //     }
    // };

    // let image_info: Option<String> = match redis::cmd("GET")
    //     .arg(&format!("image-info:upload:{}", filename))
    //     .query_async::<_, Option<String>>(&mut *redis_conn)
    //     .await {
    //         Ok(Some(info)) => Some(info),
    //         Ok(None) => None,
    //         Err(err) => {
    //             log::error!("Failed to get image info from Redis: {}", err);
    //             return Err("Failed to get image info from Redis.".into());
    //         }
    // };

    // if None == image_info {
    //     log::error!("Image info not found in Redis: {}", filename);
    //     return Err("Image info not found in Redis.".into());
    // }

    // let image_info: ImageInfo = match json::from_str(&image_info.unwrap()) {
    //     Ok(info) => info,
    //     Err(err) => {
    //         log::error!("Failed to parse image info: {}", err);
    //         return Err("Failed to parse image info.".into());
    //     }
    // };

    let message = MlUploadAnalyzeMessage {
        filename: filename.to_string(),
    };

    // Send task to ML neighbors using queue
    let task = RsmqDsQueue::UploadAnalyzeMl;
    match rsmq_pool.send_message(
        &task.as_str(),
        json::to_string(&message).unwrap(),
        None,
    ).await {
        Ok(_) => {
            log::info!("Sent message to RSMQ queue: {}", task.as_str());
            Ok(())
        },
        Err(err) => {
            log::error!("Failed to send message to RSMQ queue: {}: {}", task.as_str(), err);
            Err("Failed to send message to RSMQ queue.".into())
        }
    }

}

pub async fn compress_normal(
    filename: &str,
    bucket_images: &Bucket,
    bucket_images_compressed: &Bucket,
    bucket_images_thumbs: &Bucket,
    redis_pool: &Pool<RedisConnectionManager>,
    rsmq_pool: &mut PooledRsmq,
) -> Result<(), String> {
    log::info!("Downloading image: {}", filename);
    let original_file = match crate::tasks::utils::files::tmp::download_s3_file(
        &bucket_images,
        &filename
    ).await {
        Ok(data) => {
            log::debug!("Downloaded image from S3");
            data
        },
        Err(err) => {
            log::error!("Failed to download image from S3: {}", err);
            let _ = send_to_error_queue(
                &TaskType::CompressImage { filename: filename.to_string() },
                rsmq_pool
            ).await;
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
        log::info!("File is already small enough, copying to comp bucket.");
        compression_params_comp = None;
        compression_params_thumb = Some(job::CompressionParams {
            quality: 60.,
            size_ratio: 0.9
        })
    } else if original_file_size < 5_000_000 {
        log::info!("File is not small enough for comp bucket, compressing it.");
        compression_params_comp = Some(job::CompressionParams {
            quality: 90.,
            size_ratio: 0.9
        });
        compression_params_thumb = Some(job::CompressionParams {
            quality: 60.,
            size_ratio: 0.7
        });
    } else if original_file_size < 15_000_000 {
        log::info!("File is not small enough for comp bucket, compressing it.");
        compression_params_comp = Some(job::CompressionParams {
            quality: 85.,
            size_ratio: 0.85
        });
        compression_params_thumb = Some(job::CompressionParams {
            quality: 60.,
            size_ratio: 0.6
        });
    } else {
        log::info!("File is not small enough for comp bucket, compressing it.");
        compression_params_comp = Some(job::CompressionParams {
            quality: 80.,
            size_ratio: 0.8
        });
        compression_params_thumb = Some(job::CompressionParams {
            quality: 60.,
            size_ratio: 0.6
        });
    }

    let compressed_result: Result<(), ()>;
    let thumb_result: Result<(), ()>;
    // Compress image
    if let Some(params) = compression_params_comp {
        compressed_result = match job::compress(
            &original_file,
            &filename,
            &bucket_images_compressed,
            params
        ).await {
            Ok(_) => {
                log::info!("Compressed image (comp bucket): {:?}", filename);
                Ok(())
            },
            Err(err) => {
                log::error!("Failed to compress image (comp bucket), failing: {}", err);
                let _ = send_to_error_queue(
                    &TaskType::CompressImage { filename: filename.to_string() },
                    rsmq_pool
                ).await;
                Err(())
            },
        }
    } else {
        log::info!("File is already small enough, copying to comp bucket.");
        compressed_result = match bucket_images_compressed.put_object(&filename, original_file.as_slice()).await {
            Ok(_) => {
                log::info!("Copied image to comp bucket.");
                Ok(())
            },
            Err(err) => {
                log::error!("Failed to copy image to comp bucket: {}", err);
                let _ = send_to_error_queue(
                    &TaskType::CompressImage { filename: filename.to_string() },
                    rsmq_pool
                ).await;
                Err(())
            }
        }
    };

    // Send upload task for ML here since it only uses the comp bucket
    send_ml_upload_task(&filename, rsmq_pool).await?;

    if let Some(params) = compression_params_thumb {
        thumb_result = match job::compress(
            &original_file,
            &filename,
            &bucket_images_thumbs,
            params
        ).await {
            Ok(_) => {
                log::info!("Compressed image (thumb bucket): {:?}", filename);
                Ok(())
            },
            Err(err) => {
                log::error!("Failed to compress image (thumb bucket), failing: {}", err);
                let _ = send_to_error_queue(
                    &TaskType::CompressImage { filename: filename.to_string() },
                    rsmq_pool
                ).await;
                Err(())
            }
        }
    } else {
        log::info!("File is already small enough, copying to thumb bucket.");
        thumb_result = match bucket_images_thumbs.put_object(&filename, original_file.as_slice()).await {
            Ok(_) => {
                log::info!("Copied image to thumb bucket.");
                Ok(())
            },
            Err(err) => {
                log::error!("Failed to copy image to thumb bucket: {}", err);
                let _ = send_to_error_queue(
                    &TaskType::CompressImage { filename: filename.to_string() },
                    rsmq_pool
                ).await;
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
