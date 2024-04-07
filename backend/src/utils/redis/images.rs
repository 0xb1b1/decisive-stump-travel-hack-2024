use bb8_redis;
use redis;

use crate::models::http::images::ImageInfo;

// use super::galleries::get_main_gallery;

pub async fn set_image_info(
    image_info: &ImageInfo,
    redis_pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
) -> Result<(), String> {
    let mut conn = match redis_pool.get().await {
        Ok(conn) => conn,
        Err(e) => {
            log::error!("Failed to get connection from Redis pool: {}", e);
            return Err(format!("Failed to get connection from Redis pool: {}", e).into());
        }
    };

    // Set key
    let _: () = match redis::cmd("SET")
        .arg(format!("image-info:upload:{}", image_info.filename))
        .arg(serde_json::to_string(&image_info).unwrap())
        .arg("EX")
        .arg(60 * 60 * 12) // 12 hours
        .query_async::<_, ()>(&mut *conn)
        .await
    {
        Ok(_) => {
            log::info!("Image info set: image-info:upload:{}", image_info.filename);
            return Ok(());
        }
        Err(e) => {
            log::error!("Failed to set image info: {}", e);
            return Err(format!("Failed to set image info: {}", e).into());
        }
    };
}

// pub async fn get_s3_presigned_urls(
//     filename: &str,
//     redis_pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
// ) -> Result<Option<S3PresignedUrls>, String> {
//     let full_gallery = match get_main_gallery(redis_pool).await {
//         Ok(gallery) => gallery,
//         Err(_) => {
//             log::error!("Failed to get main gallery");
//             return Err("Failed to get main gallery".into());
//         }
//     };

//     get_s3_presigned_urls_with_gallery(filename, &full_gallery).await
// }

// pub async fn get_s3_presigned_urls_with_gallery(
//     filename: &str,
//     gallery: &RedisGalleryStore,
// ) -> Result<Option<S3PresignedUrls>, String> {
//     let image_info: &ImageInfoGallery =
//         match gallery.images.iter().find(|img| img.filename == filename) {
//             Some(info) => info,
//             None => {
//                 log::error!("Failed to find image info for filename: {}", filename);
//                 return Err("Failed to find image info".into());
//             }
//         };

//     Ok(image_info.s3_presigned_urls.clone())
// }
