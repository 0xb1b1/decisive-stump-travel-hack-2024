use rsmq_async::PooledRsmq;
use s3::Bucket;

use crate::{enums::worker::TaskType, tasks::task_types::utils::queues::send_to_error_queue};

pub async fn delete_from_all_buckets(
    filename: &str,
    bucket_images: &Bucket,
    bucket_images_compressed: &Bucket,
    bucket_images_thumbs: &Bucket,
    rsmq_pool: &mut PooledRsmq,
) -> Result<(), String> {
    log::info!("Deleting image from images bucket: {}", filename);
    let normal_result = match bucket_images.delete_object(&filename).await {
        Ok(_) => {
            log::info!("Deleted image from images bucket.");
            Ok(())
        },
        Err(err) => {
            log::error!("Failed to delete image from images bucket: {}", err);
            Err(())
        }
    };

    log::info!("Deleting image from images-comp bucket: {}", filename);
    let compressed_result = match bucket_images_compressed.delete_object(&filename).await {
        Ok(_) => {
            log::info!("Deleted image from images-comp bucket.");
            Ok(())
        },
        Err(err) => {
            log::error!("Failed to delete image from images-comp bucket: {}", err);
            Err(())
        }
    };

    log::info!("Deleting image from images-thumbs bucket: {}", filename);
    let thumb_result = match bucket_images_thumbs.delete_object(&filename).await {
        Ok(_) => {
            log::info!("Deleted image from images-thumbs bucket.");
            Ok(())
        },
        Err(err) => {
            log::error!("Failed to delete image from images-thumbs bucket: {}", err);
            Err(())
        }
    };

    if normal_result.is_ok() && compressed_result.is_ok() && thumb_result.is_ok() {
        Ok(())
    } else {
        let _ = send_to_error_queue(
            &TaskType::DeleteImage { filename: filename.to_string() },
            rsmq_pool
        ).await;
        Err("Failed to delete image from all buckets. Sending to error queue.".to_string())
    }
}
