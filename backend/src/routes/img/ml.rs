use async_std::task;
use log;
use rocket::{http::Status, response::status, serde::json::Json};
use s3::Bucket;

use ds_travel_hack_2024::utils::s3::images::get_img;
use ds_travel_hack_2024::locks::{self, ml_analyze::MlQueryType};
use ds_travel_hack_2024::models::http::ml_user::{MLAnalyzeImage, MLAnalyzeImageResponse};

pub fn routes() -> Vec<rocket::Route> {
    routes![ml_analyze_image]
}

// accept json of MLAnalyzeImage
#[patch("/ml/analyze", data = "<image>")]
pub async fn ml_analyze_image(
    image: Json<MLAnalyzeImage>,
    bucket: &rocket::State<Bucket>,
    pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
) -> status::Custom<Json<MLAnalyzeImageResponse>> {
    log::debug!("ML Analyze request received: {:?}", image);

    // Check if ML Analyze is occupied
    // TODO: Replace by Redis Queue?
    let mut lock_counter = 0;
    loop {
        let is_locked = match locks::ml_analyze::check(&MlQueryType::AnalyzeImage, pool).await {
            Ok(locked) => locked,
            Err(e) => {
                log::error!("Failed to check ML Analyze lock: {}", e);
                return status::Custom(
                    Status::InternalServerError,
                    Json(MLAnalyzeImageResponse {
                        is_ml_processed: false,
                        tags: None,
                        filename: image.filename.clone(),
                        error: Some(String::from("Failed to check ML Analyze lock.")),
                    }),
                );
            }
        };
        if is_locked {
            if lock_counter > 20 {
                // TODO: Needs to be configurable via env.
                log::error!(
                    "Another ML Analyze request is already being processed. Lock counter exceeded."
                );
                return status::Custom(
                    Status::InternalServerError,
                    Json(MLAnalyzeImageResponse {
                        is_ml_processed: false,
                        tags: None,
                        filename: image.filename.clone(),
                        error: Some(String::from("Another ML Analyze request is already being processed. Lock counter exceeded."))
                    }),
                );
            }
            log::debug!("Another ML Analyze request is already being processed. Waiting for it to finish...");
            task::sleep(std::time::Duration::from_secs(2)).await;
            lock_counter += 1;
        } else {
            break;
        }
    }

    // Lock ML Analyze
    match locks::ml_analyze::lock(&MlQueryType::AnalyzeImage, pool).await {
        Ok(_) => log::info!("ML Analyze locked."),
        Err(e) => {
            log::error!("Failed to lock ML Analyze: {}", e);
            locks::ml_analyze::unlock(&MlQueryType::AnalyzeImage, pool)
                .await
                .unwrap();
            return status::Custom(
                Status::InternalServerError,
                Json(MLAnalyzeImageResponse {
                    is_ml_processed: false,
                    tags: None,
                    filename: image.filename.clone(),
                    error: Some(String::from("Failed to lock ML Analyze.")),
                }),
            );
        }
    }

    // Check if image exists
    // TODO: Do I have to do this here? Ask ML.
    match get_img(&image.filename, &bucket).await {
        Some(_) => {
            log::debug!("Image found: {}", &image.filename);
        }
        None => {
            log::error!("Image not found: {}", &image.filename);
            locks::ml_analyze::unlock(&MlQueryType::AnalyzeImage, pool)
                .await
                .unwrap();
            return status::Custom(
                Status::InternalServerError,
                Json(MLAnalyzeImageResponse {
                    is_ml_processed: false,
                    tags: None,
                    filename: image.filename.clone(),
                    error: Some(String::from("Image not found.")),
                }),
            );
        }
    };

    // Send request to ML server
    log::warn!("TODO: Implement ML server request.");
    // TODO: Remove sleep and add a request to ML server
    task::sleep(std::time::Duration::from_secs(5)).await;

    // TODO: Use real values
    locks::ml_analyze::unlock(&MlQueryType::AnalyzeImage, pool)
        .await
        .unwrap();
    return status::Custom(
        Status::Ok,
        Json(MLAnalyzeImageResponse {
            is_ml_processed: true,
            tags: Some(vec![String::from("tag1"), String::from("tag2")]),
            filename: image.filename.clone(),
            error: None,
        }),
    );
}
