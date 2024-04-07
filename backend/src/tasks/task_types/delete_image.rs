use rsmq_async::PooledRsmq;
use s3::Bucket;

use crate::config::DsConfig;
use crate::enums::worker::TaskType;
use crate::tasks::task_types::utils::queues::send_to_error_queue;

pub async fn delete_image(
    filename: &str,
    bucket_images: &Bucket,
    bucket_images_compressed: &Bucket,
    bucket_images_thumbs: &Bucket,
    rsmq_pool: &mut PooledRsmq,
    config: &DsConfig,
) {
    log::debug!("Deleting image from all buckets... ({})", filename);
    let del_buckets = delete_from_all_buckets(
        filename,
        bucket_images,
        bucket_images_compressed,
        bucket_images_thumbs,
        rsmq_pool,
    )
    .await;
    log::debug!("Is image deleted from all buckets: {}", del_buckets.is_ok());

    log::debug!("Deleting image from ML service...");
    let del_ml = reqwest::Client::new()
        .delete(&format!("{}/images/del/{}", config.svc_ml_fast, filename))
        .send()
        .await;
    log::debug!("Is image deleted from ML service: {}", del_ml.is_ok());
    log::debug!(
        "Deletion request status code: {}",
        del_ml.as_ref().unwrap().status()
    );
}

async fn delete_from_all_buckets(
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
        }
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
        }
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
        }
        Err(err) => {
            log::error!("Failed to delete image from images-thumbs bucket: {}", err);
            Err(())
        }
    };

    if normal_result.is_ok() && compressed_result.is_ok() && thumb_result.is_ok() {
        Ok(())
    } else {
        let _ = send_to_error_queue(
            &TaskType::DeleteImage {
                filename: filename.to_string(),
            },
            rsmq_pool,
        )
        .await;
        Err("Failed to delete image from all buckets. Sending to error queue.".to_string())
    }
}
