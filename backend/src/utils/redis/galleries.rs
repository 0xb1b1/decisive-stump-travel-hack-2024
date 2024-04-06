use bb8_redis;
use redis;

use crate::models::http::main_page::RedisGalleryStore;

pub async fn get_main_gallery(
    redis_pool: &bb8::Pool<bb8_redis::RedisConnectionManager>,
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
            RedisGalleryStore {
                error: Some("Gallery not found".into()),
                images: vec![],
            }
        }
        Err(e) => {
            log::error!("Failed to get gallery: {}", e);
            return Err(format!("Failed to get gallery: {}", e).into());
        }
    };

    Ok(gallery)
}

pub async fn get_gallery_by_token(
    token: &str,
    redis_pool: &bb8::Pool<bb8_redis::RedisConnectionManager>,
) -> Option<RedisGalleryStore> {
    let mut conn = match redis_pool.get().await {
        Ok(conn) => conn,
        Err(e) => {
            log::error!("Failed to get connection from Redis pool: {}", e);
            return None;
        }
    };

    // Get key
    let gallery: RedisGalleryStore = match redis::cmd("GET")
        .arg(format!("images:collections:main:full:by_token:{}", token))
        .query_async::<_, Option<String>>(&mut *conn)
        .await
    {
        Ok(Some(gallery)) => {
            log::info!(
                "Gallery found: images:collections:main:full:by_token:{}",
                token
            );
            match serde_json::from_str(&gallery) {
                Ok(gallery) => gallery,
                Err(e) => {
                    log::error!("Failed to parse gallery: {}", e);
                    return None;
                }
            }
        }
        Ok(None) => {
            log::info!(
                "Gallery not found: images:collections:main:full:by_token:{}",
                token
            );
            RedisGalleryStore {
                error: Some("Gallery not found".into()),
                images: vec![],
            }
        }
        Err(e) => {
            log::error!("Failed to get gallery: {}", e);
            return None;
        }
    };

    Some(gallery)
}

pub async fn set_gallery_by_token(
    token: &str,
    gallery: &RedisGalleryStore,
    redis_pool: &bb8::Pool<bb8_redis::RedisConnectionManager>,
) -> Result<(), String> {
    let mut conn = match redis_pool.get().await {
        Ok(conn) => conn,
        Err(e) => {
            log::error!("Failed to get connection from Redis pool: {}", e);
            return Err(format!("Failed to get connection from Redis pool: {}", e).into());
        }
    };

    // Convert GalleryResponse to RedisGalleryStore
    let gallery = RedisGalleryStore {
        images: gallery.images.clone(),
        error: None,
    };

    // Set key
    let _: () = match redis::cmd("SET")
        .arg(format!("images:collections:main:full:by_token:{}", token))
        .arg(serde_json::to_string(&gallery).unwrap())
        .arg("EX")
        .arg(60 * 120) // 2 hours
        .query_async::<_, ()>(&mut *conn)
        .await
    {
        Ok(_) => {
            log::info!(
                "Gallery set: images:collections:main:full:by_token:{}",
                token
            );
            return Ok(());
        }
        Err(e) => {
            log::error!("Failed to set gallery: {}", e);
            return Err(format!("Failed to set gallery: {}", e).into());
        }
    };
}

pub async fn ml_gallery_exists(redis_pool: &bb8::Pool<bb8_redis::RedisConnectionManager>) -> bool {
    let mut conn = match redis_pool.get().await {
        Ok(conn) => conn,
        Err(e) => {
            log::error!("Failed to get connection from Redis pool: {}", e);
            return false;
        }
    };

    // Get key
    let gallery: RedisGalleryStore = match redis::cmd("EXISTS")
        .arg("images:collections:main")
        .query_async::<_, i32>(&mut *conn)
        .await
    {
        Ok(1) => {
            log::info!("Gallery found: images:collections:main");
            match get_main_gallery(redis_pool).await {
                Ok(gallery) => gallery,
                Err(_) => RedisGalleryStore {
                    images: vec![],
                    error: Some("Gallery not found".into()),
                },
            }
        }
        _ => RedisGalleryStore {
            images: vec![],
            error: Some("Gallery not found".into()),
        }
    };

    gallery.images.len() > 0
}
