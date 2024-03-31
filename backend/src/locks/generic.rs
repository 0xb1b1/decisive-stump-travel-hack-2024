use bb8_redis;
use redis;

pub async fn lock(
    prefix: &str,
    key: &str,
    expiration_seconds: u32,
    pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>
) -> Result<(), String> {
    let mut conn = match pool.get().await {
        Ok(conn) => conn,
        Err(e) => {
            log::error!("Failed to get connection from Redis pool: {}", e);
            return Err(format!("Failed to get connection from Redis pool: {}", e).into());
        }
    };

    // Set key
    let _: () = match redis::cmd("SET")
        .arg(format!("lock-{}-{}", prefix, key))
        .arg("1")
        .arg("EX")
        .arg(expiration_seconds)
        .query_async::<_, ()>(&mut *conn)
        .await {
            Ok(_) => {
                log::info!("Lock set: lock-{}-{}", prefix, key);
                return Ok(());
            },
            Err(e) => {
                log::error!("Failed to set lock: {}", e);
                return Err(format!("Failed to set lock: {}", e).into());
            }
        };
}

pub async fn unlock(prefix: &str, key: &str, pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>) -> Result<(), String> {
    let mut conn = match pool.get().await {
        Ok(conn) => conn,
        Err(e) => {
            log::error!("Failed to get connection from Redis pool: {}", e);
            return Err(format!("Failed to get connection from Redis pool: {}", e).into());
        }
    };

    // Delete key
    log::debug!("Removing lock: lock-{}-{}", prefix, key);
    let _: () = match redis::cmd("DEL")
        .arg(format!("lock-{}-{}", prefix, key))
        .query_async::<_, ()>(&mut *conn)
        .await {
            Ok(_) => {
                log::info!("Lock removed: lock-{}-{}", prefix, key);
                return Ok(());
            },
            Err(e) => {
                log::error!("Failed to remove lock: {}", e);
                return Err(format!("Failed to remove lock: {}", e).into());
            }
    };
}

pub async fn check(prefix: &str, key: &str, pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>) -> Result<bool, String> {
    let mut conn = match pool.get().await {
        Ok(conn) => conn,
        Err(e) => {
            log::error!("Failed to get connection from Redis pool: {}", e);
            return Err(format!("Failed to get connection from Redis pool: {}", e).into());
        }
    };

    // Check if key exists
    match redis::cmd("GET")
        .arg(format!("{}-{}", prefix, key))
        .query_async(&mut *conn)
        .await {
            Ok(data) => {
                match data {
                    redis::Value::Data(_) => {
                        log::info!("Lock exists: lock-{}-{}", prefix, key);
                        return Ok(true);
                    },
                    _ => {
                        log::info!("Lock does not exist: lock-{}-{}", prefix, key);
                        return Ok(false);
                    }
                }
            },
            Err(e) => {
                log::error!("Failed to check lock: {}", e);
                return Err(format!("Failed to check lock: {}", e).into());
            }
        }
}