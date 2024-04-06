use rocket::{
    http::Status,
    response::status,
    serde::json::Json, // form::Form,
};
// use rocket::http::{
//     ContentType,
//     MediaType
// };
// use rsmq_async::{PooledRsmq, RsmqConnection};
// use tokio::io::AsyncReadExt;
use log;
// use s3::Bucket;

// use crate::enums::rsmq::RsmqDsQueue;
// use crate::enums::worker::TaskType;
use ds_travel_hack_2024::models::http::main_page::RedisGalleryStore;
// use crate::utils::s3::images::get_img;
// use ds_travel_hack_2024::utils;

use crate::config::DsConfig;

pub fn routes() -> Vec<rocket::Route> {
    routes![get_photo_neighbors,]
}

#[get("/neighbors/<filename>?<amount>")]
pub async fn get_photo_neighbors(
    filename: &str,
    amount: Option<u16>,
    config: &rocket::State<DsConfig>,
) -> status::Custom<Json<RedisGalleryStore>> {
    log::info!("Processing GetPhotoNeighbors task for file: {}", filename);

    let client = reqwest::Client::builder()
        .timeout(std::time::Duration::from_secs(40))
        .build()
        .unwrap();

    let amount_param = amount.unwrap_or(10).to_string();
    let params: Vec<(&str, &str)> = vec![("neighbors_limit", &amount_param)];
    let url = match reqwest::Url::parse_with_params(
        &format!("{}/images/neighbors/{}", config.svc_ml_fast, filename),
        params,
    ) {
        Ok(url) => url,
        Err(e) => {
            log::error!("Failed to parse ML request URL: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(RedisGalleryStore {
                    error: Some("Failed to parse ML request URL".into()),
                    ..RedisGalleryStore::new()
                }),
            );
        }
    };

    let response: RedisGalleryStore = match client.get(url).send().await {
        Ok(res) => match res.text().await {
            Ok(json) => match serde_json::from_str(&json) {
                Ok(response) => response,
                Err(e) => {
                    log::error!("Failed to parse JSON response: {}", e);
                    log::debug!("Raw response: {}", json);
                    return status::Custom(
                        Status::InternalServerError,
                        Json(RedisGalleryStore {
                            error: Some("Failed to parse JSON response".into()),
                            ..RedisGalleryStore::new()
                        }),
                    );
                }
            },
            Err(e) => {
                log::error!("Failed to get text from response: {}", e);
                return status::Custom(
                    Status::InternalServerError,
                    Json(RedisGalleryStore {
                        error: Some("Failed to get text from response".into()),
                        ..RedisGalleryStore::new()
                    }),
                );
            }
        },
        Err(e) => {
            log::error!("Failed to get response from ML service: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(RedisGalleryStore {
                    error: Some("Failed to get response from ML service".into()),
                    ..RedisGalleryStore::new()
                }),
            );
        }
    };

    status::Custom(Status::Ok, Json(response))
}
