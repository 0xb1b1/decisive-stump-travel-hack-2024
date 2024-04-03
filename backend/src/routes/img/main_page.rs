use rocket::{
    serde::json::Json,  // form::Form,
    http::Status,
    response::status,
};
// use rocket::http::{
//     ContentType,
//     MediaType
// };
// use rsmq_async::{PooledRsmq, RsmqConnection};
// use tokio::io::AsyncReadExt;
use log;
use s3::Bucket;
use redis::RedisError;

// use crate::enums::rsmq::RsmqDsQueue;
// use crate::enums::worker::TaskType;
use crate::models::http::images::{ImageInfo, ImageInfoGallery};
use crate::models::http::main_page::{GalleryResponse, RedisGalleryStore};
// use crate::utils::s3::images::get_img;
use crate::utils;

pub fn routes() -> Vec<rocket::Route> {
    routes![
        get_gallery,
    ]
}

#[get("/gallery?<token>&<limit>")]
async fn get_gallery(
    token: Option<String>,
    limit: Option<u32>,
    bucket: &rocket::State<Bucket>,  // TODO: Remove this after moving parser to worker?
    redis_pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
) -> status::Custom<Json<GalleryResponse>> {
    log::debug!("Gallery request received ({:?}): limit={:?}", token, limit);

    // Get `images::collections::main` key value from redis_pool
    let mut conn = match redis_pool.get().await {
        Ok(conn) => conn,
        Err(e) => {
            log::error!("Failed to get Redis connection: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(GalleryResponse {
                    images: vec![],
                    error: Some("Failed to get Redis connection.".to_string())
                }),
            );
        }
    };

    // Get images:collections:main:full from redis
    let gallery: RedisGalleryStore = match utils::redis::galleries::get_main_gallery(&redis_pool).await {
        Ok(gallery) => gallery,
        Err(e) => {
            log::error!("Failed to get gallery from Redis: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(GalleryResponse {
                    images: vec![],
                    error: Some("Failed to get gallery from Redis.".to_string())
                }),
            );
        }
    };

    // Send the gallery
    status::Custom(
        Status::Ok,
        Json(GalleryResponse {
            images: gallery.images,
            error: None
        })
    )
}
