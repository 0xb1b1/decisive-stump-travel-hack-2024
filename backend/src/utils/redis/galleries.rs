use bb8_redis;
use redis;

use crate::models::http::main_page::RedisGalleryStore;

pub async fn get_main_gallery(
    redis_pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
) -> Result<RedisGalleryStore, String> {
    let mut conn = match redis_pool.get().await {
        Ok(conn) => conn,
        Err(e) => {
            log::error!("Failed to get connection from Redis pool: {}", e);
            return Err(format!("Failed to get connection from Redis pool: {}", e).into());
        }
    };

    // Get key
    let gallery: RedisGalleryStore = match redis::cmd("GET")
        .arg("images:collections:main:full")
        .query_async::<_, Option<String>>(&mut *conn)
        .await
    {
        Ok(Some(gallery)) => {
            log::info!("Gallery found: images:collections:main:full");
            match serde_json::from_str(&gallery) {
                Ok(gallery) => gallery,
                Err(e) => {
                    log::error!("Failed to parse gallery: {}", e);
                    return Err(format!("Failed to parse gallery: {}", e).into());
                }
            }
        }
        Ok(None) => {
            log::info!("Gallery not found: images:collections:main:full");
            RedisGalleryStore { images: vec![] }
        }
        Err(e) => {
            log::error!("Failed to get gallery: {}", e);
            return Err(format!("Failed to get gallery: {}", e).into());
        }
    };

    Ok(gallery)
}
