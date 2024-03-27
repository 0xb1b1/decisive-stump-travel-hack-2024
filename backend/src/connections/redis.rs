use bb8;
use bb8_redis;
use std::env;

pub async fn pool() -> Result<bb8::Pool<bb8_redis::RedisConnectionManager>, String> {
    let manager = bb8_redis::RedisConnectionManager::new(
        match env::var("DS_REDIS_URL") {
            Ok(var) => var,
            Err(_) => {
                return Err("Redis URL not defined.".into());
            }
        }
    ).unwrap();

    let pool = bb8::Pool::builder()
        .build(manager)
        .await
        .unwrap();
    Ok(pool)
}
