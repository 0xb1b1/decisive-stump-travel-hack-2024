use rocket::{
    serde::json::Json, form::Form,
    http::Status,
    response::status,
};
use rocket::http::{
    ContentType,
    MediaType
};
use rsmq_async::{PooledRsmq, RsmqConnection};
use tokio::io::AsyncReadExt;
use log;
use s3::Bucket;
use redis::RedisError;

use crate::enums::rsmq::RsmqDsQueue;
use crate::enums::worker::TaskType;
use crate::models::http::images::ImageInfo;
use crate::models::http::main_page::{GalleryResponse, RedisGalleryStore};
use crate::utils::s3::images::get_img;
use crate::{locks, utils};

pub fn routes() -> Vec<rocket::Route> {
    routes![
        get_gallery,
    ]
}

#[get("/gallery")]
async fn get_gallery(
    redis_pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
) -> status::Custom<Json<GalleryResponse>> {
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

   let gallery: Result<String, RedisError> = redis::cmd("GET")
        .arg("images:collections:main")
        .query_async(&mut *conn)
        .await;

    if let Ok(gallery) = gallery {
        log::debug!("Using cached gallery from Redis.");
        let gallery: RedisGalleryStore = match serde_json::from_str(&gallery) {
            Ok(gallery) => gallery,
            Err(e) => {
                log::error!("Failed to parse gallery from Redis: {}", e);
                return status::Custom(
                    Status::InternalServerError,
                    Json(GalleryResponse {
                        images: vec![],
                        error: Some("Failed to parse gallery from Redis.".to_string())
                    }),
                );
            }
        };

        status::Custom(
            Status::Ok,
            Json(GalleryResponse {
                images: gallery.images,
                error: None
            }),
        )
    } else {
        return status::Custom(
            Status::InternalServerError,
            Json(GalleryResponse {
                images: vec![],
                error: Some("TODO: Request a gallery update".to_string())  // TODO: Request a gallery update (using the worker, we should issue an error message to the client)
            }),
        );
    }
}
