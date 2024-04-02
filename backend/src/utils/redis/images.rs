use crate::models::http::images::ImageInfo;
use redis;
use bb8_redis;



pub async fn set_image_info(image_info: &ImageInfo, redis_pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>) -> Result<(), String> {
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
        .arg(60 * 30)  // 30 minutes
        .query_async::<_, ()>(&mut *conn)
        .await {
            Ok(_) => {
                log::info!("Image info set: image-info:upload:{}", image_info.filename);
                return Ok(());
            },
            Err(e) => {
                log::error!("Failed to set image info: {}", e);
                return Err(format!("Failed to set image info: {}", e).into());
            }
        };
}
