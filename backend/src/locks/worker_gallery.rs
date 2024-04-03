use super::generic;

pub async fn lock(pool: &bb8::Pool<bb8_redis::RedisConnectionManager>) -> Result<(), String> {
    generic::lock("worker", "gallery", 30, pool).await
}

pub async fn unlock(pool: &bb8::Pool<bb8_redis::RedisConnectionManager>) -> Result<(), String> {
    generic::unlock("worker", "gallery", pool).await
}

pub async fn check(pool: &bb8::Pool<bb8_redis::RedisConnectionManager>) -> Result<bool, String> {
    generic::check("worker", "gallery", pool).await
}
