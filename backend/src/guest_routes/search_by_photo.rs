// use std::time::Duration;

use ds_travel_hack_2024::utils::rsmq::presigned_urls::get_s3_presigned_urls_direct;
// use async_std::task;
// use ds_travel_hack_2024::enums::ml_worker::MlTaskType;
use log;
use rocket::http::{ContentType, MediaType};
use rocket::response;
use rocket::{form::Form, http::Status, response::status, serde::json::Json};
use rsmq_async::PooledRsmq;
// use rsmq_async::PooledRsmq;
use s3::Bucket;
use serde::{Deserialize, Serialize};
use tokio::io::AsyncReadExt; // Required for reading file contents (e.g. .read_to_end())

// use ds_travel_hack_2024::enums::{rsmq::RsmqDsQueue, worker::TaskType};
use ds_travel_hack_2024::locks;
use ds_travel_hack_2024::models::http::images::{ImageInfo, ImageInfoGallery, ImageUploadFailInfo, S3PresignedUrls};
use ds_travel_hack_2024::models::http::uploads::{
    ImageStatusResponse, UploadImage, UploadImageResponse,
};
// use ds_travel_hack_2024::utils;
use ds_travel_hack_2024::utils::s3::images::get_img;

use crate::config::DsConfig;
// use ds_travel_hack_2024::utils::rsmq::presigned_urls::get_s3_presigned_urls_direct;

// use crate::config::DsConfig;

pub fn routes() -> Vec<rocket::Route> {
    routes![upload_image,]
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct SearchByImageResponse {
    pub filename: Option<String>,
    pub images: Option<Vec<ImageInfoGallery>>,
    pub tags: Option<Vec<String>>,
    pub error: Option<String>,
}
impl SearchByImageResponse {
    pub fn new() -> Self {
        SearchByImageResponse {
            filename: None,
            images: None,
            tags: None,
            error: None,
        }
    }
}

#[post("/upload?<neighbors_limit>&<tags_limit>", format = "multipart/form-data", data = "<form>")]
async fn upload_image(
    form: Form<UploadImage<'_>>,
    neighbors_limit: Option<usize>,
    tags_limit: Option<usize>,
    bucket: &rocket::State<Bucket>,
    redis_pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
    rsmq_pool: &rocket::State<PooledRsmq>,
    config: &rocket::State<DsConfig>,
) -> status::Custom<Json<SearchByImageResponse>> {
    {
        let filename = match form.file.name() {
            Some(name) => name,
            None => {
                log::error!("Failed to get file name.");
                return status::Custom(
                    Status::BadRequest,
                    Json(SearchByImageResponse {
                        error: Some("Failed to get file name.".into()),
                        ..SearchByImageResponse::new()
                    }),
                );
            }
        };

        log::debug!("Got an image: ({})", filename);
    }
    match &form.tags {
        Some(tags) => log::debug!("Image tags: {:?}", tags),
        None => log::debug!("No tags provided."), // TODO: remove tags from uploads entirely.
    }

    let file_type: &ContentType = match form.file.content_type() {
        Some(t) => t,
        None => {
            log::error!("Failed to get file type.");
            return status::Custom(
                Status::BadRequest,
                Json(SearchByImageResponse {
                    error: Some("Failed to get file type.".into()),
                    ..SearchByImageResponse::new()
                }),
            );
        }
    };
    // Reject non-image files
    if !file_type.is_jpeg() && !file_type.is_png() {
        log::error!("Invalid file type: {:?}", file_type);
        return status::Custom(
            Status::UnsupportedMediaType,
            Json(SearchByImageResponse {
                error: Some("Invalid file type.".into()),
                ..SearchByImageResponse::new()
            }),
        );
    }

    // Create a proper file path
    let mut contents: Vec<u8> = Vec::new();
    let mut file_buffer = form.file.open().await.unwrap();
    file_buffer.read_to_end(&mut contents).await.unwrap();
    log::debug!("File size: {} bytes", contents.len());

    let file_name: String;
    let file_path: String;
    {
        let media_type: &MediaType = file_type.media_type();
        let file_hash = ds_travel_hack_2024::utils::hash::hash_file(&contents);

        let file_ext;
        if media_type.sub() == "jpeg" {
            file_ext = "jpg";
        } else {
            file_ext = media_type.sub().as_str();
        }

        file_name = format!("{}.{}", file_hash, file_ext);
        file_path = file_name.clone(); // For flexibility
        log::info!("File will be saved in S3 as {}", &file_path);
    }

    let s3_image_exists = match get_img(&file_path, &bucket).await {
        Some(_) => true,
        None => false,
    };

    // Check if the file already exists
    match s3_image_exists {
        true => log::error!("File already exists, using it: {}", &file_path),
        false => (),
    };

    // The following is done via a separate request
    // task::sleep(Duration::from_secs(10)).await;  // [TEMP]: Simulate ML model processing

    if !s3_image_exists {
        log::debug!("Saving file to: {}", &file_path);
        let mut file_buffer = form.file.open().await.unwrap();
        match bucket.put_object_stream(&mut file_buffer, &file_path).await {
            Ok(_) => {
                log::debug!("Data sent to S3.");
                locks::image_upload::unlock(&file_path, &redis_pool)
                    .await
                    .unwrap();
            }
            Err(e) => {
                log::error!("Failed to send data to S3: {}", e);
                locks::image_upload::unlock(&file_path, &redis_pool)
                    .await
                    .unwrap();
                return status::Custom(
                    Status::InternalServerError,
                    Json(SearchByImageResponse {
                        error: Some(format!("Failed to send data to S3: {}", e)),
                        ..SearchByImageResponse::new()
                    }),
                );
            }
        };
    } else {
        log::debug!("Not saving file again — it already exists: {}", file_name);
    }

    // Get similar images search result from ML
    let neighbors_lim = neighbors_limit.unwrap_or(10).to_string();
    let tags_lim = tags_limit.unwrap_or(10).to_string();
    let params: Vec<(&str, &str)> = vec![
        ("filename", &file_name),
        ("neighbors_limit", &neighbors_lim),
        ("tags_limit", &tags_lim),
    ];

    let url = match reqwest::Url::parse_with_params(
        &format!("{}/search/image", config.svc_ml_upload),
        params
    ) {
        Ok(url) => url,
        Err(err) => {
            log::error!("Failed to parse URL: {}", err);
            return status::Custom(
                Status::InternalServerError,
                Json(SearchByImageResponse {
                    filename: Some(file_name),
                    images: None,
                    tags: None,
                    error: Some("Failed to parse URL".to_string()),
                }),
            );
        }
    };

    let client = reqwest::Client::builder()
        .timeout(std::time::Duration::from_secs(40))
        .build()
        .unwrap();

    let mut response = match client.post(url).send().await {
        Ok(response) => match response.text().await {
            Ok(images_str) => match serde_json::from_str(&images_str) {
                Ok(images) => images,
                Err(err) => {
                    log::error!("Failed to parse response: {}", err);
                    log::error!("Raw response: {}", images_str);
                    SearchByImageResponse {
                        filename: Some(file_name.clone()),
                        images: None,
                        tags: None,
                        error: Some("Failed to parse response".to_string()),
                    }
                }
            },
            Err(err) => {
                log::error!("Failed to parse response: {}", err);
                SearchByImageResponse {
                    filename: Some(file_name.clone()),
                    images: None,
                    tags: None,
                    error: Some("Failed to parse response".to_string()),
                }
            }
        },
        Err(err) => {
            log::error!("Failed to send request: {}", err);
            SearchByImageResponse {
                filename: Some(file_name.clone()),
                images: None,
                tags: None,
                error: Some("Failed to send request".to_string()),
            }
        }
    };

    // If images is None, return the struct
    let tmp_resp = response.clone();
    if tmp_resp.images.is_none() {
        log::warn!("No images in response by ML");
        return status::Custom(Status::Ok, Json(response));
    }

    let mut new_images: Vec<ImageInfoGallery> = response.images.clone().unwrap();

    // Add Presigned S3 URLs
    for image in response.images.clone().unwrap() {
        let mut new_image = image.clone();
        new_image.s3_presigned_urls =
            match get_s3_presigned_urls_direct(
            &image.filename,
            None,
            redis_pool,
            rsmq_pool,
            30,
        )
            .await
            {
                Ok(urls) => Some(urls),
                Err(_) => {
                    log::error!(
                        "Failed to get S3 presigned URLs for image: {}",
                        image.filename
                    );
                    None
            }
        };

        log::debug!("Presigned S3 URLs for image {:?}", &new_image);

        new_images.push(new_image);
    }

    response.images = Some(new_images);
    log::debug!("New images: {:?}", response.images.clone());

    status::Custom(
        Status::Ok,
        Json(response),
    )
}
