use core::fmt;

use super::generic;

pub enum MlQueryType {
    // ML has to be locked by query type to prevent OOM issues on the server.
    // It's probably better to use a queue, so that has to be considered.
    // However, that will require a partial rewrite of the ML part of the project.
    AnalyzeImage,
    GenerateImage
}
impl fmt::Display for MlQueryType {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            MlQueryType::AnalyzeImage => write!(f, "analyze_image"),
            MlQueryType::GenerateImage => write!(f, "generate_image")
        }
    }
}

// Return Future
pub async fn lock(query_type: &MlQueryType, pool: &bb8::Pool<bb8_redis::RedisConnectionManager>) -> Result<(), String> {
    generic::lock("ml_analyze", query_type.to_string().as_str(), 30, pool).await
}

pub async fn unlock(query_type: &MlQueryType, pool: &bb8::Pool<bb8_redis::RedisConnectionManager>) -> Result<(), String> {
    generic::unlock("ml_analyze", query_type.to_string().as_str(), pool).await
}

pub async fn check(query_type: &MlQueryType, pool: &bb8::Pool<bb8_redis::RedisConnectionManager>) -> Result<bool, String> {
    generic::check("ml_analyze", query_type.to_string().as_str(), pool).await
}
