use super::generic;

pub async fn lock(file_name: &str, pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>) -> Result<(), String> {
    generic::lock("image", file_name, 30, pool).await
}

pub async fn unlock(file_name: &str, pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>) -> Result<(), String> {
    generic::unlock("image", file_name, pool).await
}

pub async fn check(file_name: &str, pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>) -> Result<bool, String> {
    generic::check("image", file_name, pool).await
}
