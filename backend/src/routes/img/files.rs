// use rocket::http::uncased::UncasedStr;
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
use std::{
    path, fs
};
use log;
use s3::Bucket;

use crate::enums::rsmq::RsmqDsQueue;
use crate::enums::worker::TaskType;
// use crate::connections::rsmq;
use crate::models::http::uploads::{
    DeleteImageResponse, UploadImage, UploadImageResponse
};
use crate::utils::s3::images::get_img;
use crate::locks;

pub fn routes() -> Vec<rocket::Route> {
    routes![
        upload_image_large,
        upload_image,
        delete_image
    ]
}

#[post("/upload/large", format = "multipart/form-data", data = "<form>")]
async fn upload_image_large(
    form: Form<UploadImage<'_>>,
    bucket: &rocket::State<Bucket>,
    pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
    rsmq: &rocket::State<PooledRsmq>
) -> status::Custom<Json<UploadImageResponse>> {
    log::debug!("Got an image: {:?}", form.file);
    match &form.tags {
        Some(tags) => log::debug!("Image tags: {:?}", tags),
        None => log::debug!("No tags provided.")
    }

    let file_type: &ContentType = match form.file.content_type() {
        Some(t) => t,
        None => {
            log::error!("Failed to get file type.");
            return status::Custom(
                Status::BadRequest,
                Json(UploadImageResponse {
                    is_stored: false,
                    is_accepted: false,
                    is_ml_processed: Some(false),
                    tags:Some(form.tags.clone().unwrap_or_default()),
                    filename: None,
                    error: Some("Failed to get file type.".into())
                }
            ));
        }
    };
    // Reject non-image files
    if !file_type.is_jpeg() && !file_type.is_png() {
        log::error!("Invalid file type: {:?}", file_type);
        return status::Custom(
            Status::UnsupportedMediaType,
            Json(UploadImageResponse {
                is_stored: false,  // File is definitely not stored since it's not an image
                is_accepted: false,
                is_ml_processed: Some(false),
                tags: Some(form.tags.clone().unwrap_or_default()),
                filename: None,
                error: Some("Unsupported file type.".into())
            }
        ));
    }

    // Create a proper file path
    let mut file_buffer: Vec<u8> = Vec::new();
    form.file.open().await.unwrap().read_buf(&mut file_buffer).await.unwrap();

    let file_name: String;
    let file_path: String;
    {
        let media_type: &MediaType = file_type.media_type();
        let file_hash = crate::utils::hash::hash_file(
            &file_buffer
        );

        let file_ext;
        if media_type.sub() == "jpeg" {
            file_ext = "jpg";
        } else {
            file_ext = media_type.sub().as_str();
        }

        file_name = format!("{}.{}", file_hash, file_ext);
        file_path = file_name.clone();  // For flexibility
        log::debug!("File will be saved in S3 as {}", &file_path);
    }

    let s3_image_exists = match get_img(&file_path, &bucket).await {
        Some(_) => true,
        None => false
    };

    // Check if the file already exists
    match s3_image_exists {
        true => {
            log::error!("File already exists: {}", &file_path);
            return status::Custom(
                Status::Conflict,
                Json(UploadImageResponse {
                    is_stored: true,
                    is_accepted: false,
                    is_ml_processed: Some(true),  // TODO: Should be pulled from ClickHouse
                    tags: Some(form.tags.clone().unwrap_or_default()),  // TODO: Should be pulled from ClickHouse
                    filename: Some(file_name.clone()),
                    error: Some("File already exists.".into())
                }
            ));
        },
        false => ()
    }

    // Check for image lock
    let is_locked = match locks::image_upload::check(&file_path, &pool)
        .await {
            Ok(locked) => locked,
            Err(e) => {
                log::error!("Failed to check image lock: {}", e);
                return status::Custom(
                    Status::InternalServerError,
                    Json(UploadImageResponse {
                        is_stored: false,
                        is_accepted: false,
                        is_ml_processed: Some(false),
                        tags: Some(form.tags.clone().unwrap_or_default()),
                        filename: None,
                        error: Some(format!("Failed to check image lock: {}", e))
                    }
                ));
            }
        };

    if is_locked {
        log::error!("Image is locked: {}", &file_path);
        return status::Custom(
            Status::Locked,
            Json(UploadImageResponse {
                is_stored: false,
                is_accepted: false,
                is_ml_processed: Some(false),  // TODO: Should be pulled from ClickHouse
                tags: Some(form.tags.clone().unwrap_or_default()),
                filename: None,
                error: Some("Image is locked.".into())
            }
        ));
    }

    // Lock the image
    match locks::image_upload::lock(&file_path, &pool).await {
        Ok(_) => (),
        Err(e) => {
            log::error!("Failed to lock image: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(UploadImageResponse {
                    is_stored: false,
                    is_accepted: false,
                    is_ml_processed: Some(false),
                    tags: Some(form.tags.clone().unwrap_or_default()),
                    filename: None,
                    error: Some(format!("Failed to lock image: {}", e))
                }
            ));
        }
    };

    // The following is done via a separate request
    // task::sleep(Duration::from_secs(10)).await;  // [TEMP]: Simulate ML model processing

    log::debug!("Saving file to: {}", &file_path);
    let mut file_buffer = form.file.open().await.unwrap();
    match bucket.put_object_stream(&mut file_buffer, &file_path).await {
        Ok(_) => {
            log::debug!("Data sent to S3.");
            locks::image_upload::unlock(&file_path, &pool).await.unwrap();
        },
        Err(e) => {
            log::error!("Failed to send data to S3: {}", e);
            locks::image_upload::unlock(&file_path, &pool).await.unwrap();
            return status::Custom(
                Status::InternalServerError,
                Json(UploadImageResponse {
                    is_stored: true,
                    is_accepted: false,
                    is_ml_processed: None,
                    tags: Some(form.tags.clone().unwrap_or_default()),  // TODO: Should be pulled from ClickHouse (or response from ML)
                    filename: None,
                    error: Some(format!("Failed to save file: {}", e))
                }
            ));
        }
    };

    log::info!("Sending processing task for worker to RSMQ...");
    let worker_queue_msg_id = match rsmq.inner().clone().send_message(
        RsmqDsQueue::BackendWorker.as_str(),
        serde_json::to_string(&TaskType::CompressImage {
            filename: file_name.clone()
        }).unwrap().as_str(),
        None
    ).await {
        Ok(msg) => msg,
        Err(e) => {
            log::error!("Failed to send message to RSMQ: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(UploadImageResponse {
                    is_stored: true,
                    is_accepted: true,
                    is_ml_processed: Some(false),
                    tags: Some(form.tags.clone().unwrap_or_default()),
                    filename: Some(file_name),
                    error: Some(format!("Failed to send message to RSMQ: {}", e))
                }
            ));
        }
    };

    log::info!("Sent processing task for worker to RSMQ: {:?}", worker_queue_msg_id);

    status::Custom(
        Status::Ok,
        Json(UploadImageResponse {
            is_stored: true,
            is_accepted: true,
            is_ml_processed: None,
            tags: Some(form.tags.clone().unwrap_or_default()),  // TODO: Should be pulled from ClickHouse (or response from ML)
            filename: Some(file_name),
            error: None
        }
    ))
}

#[post("/upload", format = "multipart/form-data", data = "<form>")]
async fn upload_image(
    form: Form<UploadImage<'_>>,
    bucket: &rocket::State<Bucket>,
    pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
    rsmq: &rocket::State<PooledRsmq>
) -> status::Custom<Json<UploadImageResponse>> {
    log::debug!("Got an image: {:?}", form.file);
    match &form.tags {
        Some(tags) => log::debug!("Image tags: {:?}", tags),
        None => log::debug!("No tags provided.")
    }

    let file_type: &ContentType = match form.file.content_type() {
        Some(t) => t,
        None => {
            log::error!("Failed to get file type.");
            return status::Custom(
                Status::BadRequest,
                Json(UploadImageResponse {
                    is_stored: false,
                    is_accepted: false,
                    is_ml_processed: Some(false),
                    tags:Some(form.tags.clone().unwrap_or_default()),
                    filename: None,
                    error: Some("Failed to get file type.".into())
                }
            ));
        }
    };
    // Reject non-image files
    if !file_type.is_jpeg() && !file_type.is_png() {
        log::error!("Invalid file type: {:?}", file_type);
        return status::Custom(
            Status::UnsupportedMediaType,
            Json(UploadImageResponse {
                is_stored: false,  // File is definitely not stored since it's not an image
                is_accepted: false,
                is_ml_processed: Some(false),
                tags: Some(form.tags.clone().unwrap_or_default()),
                filename: None,
                error: Some("Unsupported file type.".into())
            }
        ));
    }

    // Create a proper file path
    let mut file_buffer: Vec<u8> = Vec::new();
    form.file.open().await.unwrap().read_buf(&mut file_buffer).await.unwrap();

    let file_name: String;
    let file_path: String;
    {
        let media_type: &MediaType = file_type.media_type();
        let file_hash = crate::utils::hash::hash_file(
            &file_buffer
        );

        let file_ext;
        if media_type.sub() == "jpeg" {
            file_ext = "jpg";
        } else {
            file_ext = media_type.sub().as_str();
        }

        file_name = format!("{}.{}", file_hash, file_ext);
        file_path = file_name.clone();  // For flexibility
        log::debug!("File will be saved in S3 as {}", &file_path);
    }

    let s3_image_exists = match get_img(&file_path, &bucket).await {
        Some(_) => true,
        None => false
    };

    // Check if the file already exists
    match s3_image_exists {
        true => {
            log::error!("File already exists: {}", &file_path);
            return status::Custom(
                Status::Conflict,
                Json(UploadImageResponse {
                    is_stored: true,
                    is_accepted: false,
                    is_ml_processed: Some(true),  // TODO: Should be pulled from ClickHouse
                    tags: Some(form.tags.clone().unwrap_or_default()),  // TODO: Should be pulled from ClickHouse
                    filename: Some(file_name.clone()),
                    error: Some("File already exists.".into())
                }
            ));
        },
        false => ()
    }

    // Check for image lock
    let is_locked = match locks::image_upload::check(&file_path, &pool)
        .await {
            Ok(locked) => locked,
            Err(e) => {
                log::error!("Failed to check image lock: {}", e);
                return status::Custom(
                    Status::InternalServerError,
                    Json(UploadImageResponse {
                        is_stored: false,
                        is_accepted: false,
                        is_ml_processed: Some(false),
                        tags: Some(form.tags.clone().unwrap_or_default()),
                        filename: None,
                        error: Some(format!("Failed to check image lock: {}", e))
                    }
                ));
            }
        };

    if is_locked {
        log::error!("Image is locked: {}", &file_path);
        return status::Custom(
            Status::Locked,
            Json(UploadImageResponse {
                is_stored: false,
                is_accepted: false,
                is_ml_processed: Some(false),  // TODO: Should be pulled from ClickHouse
                tags: Some(form.tags.clone().unwrap_or_default()),
                filename: None,
                error: Some("Image is locked.".into())
            }
        ));
    }

    // Lock the image
    match locks::image_upload::lock(&file_path, &pool).await {
        Ok(_) => (),
        Err(e) => {
            log::error!("Failed to lock image: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(UploadImageResponse {
                    is_stored: false,
                    is_accepted: false,
                    is_ml_processed: Some(false),
                    tags: Some(form.tags.clone().unwrap_or_default()),
                    filename: None,
                    error: Some(format!("Failed to lock image: {}", e))
                }
            ));
        }
    };

    // The following is done via a separate request
    // task::sleep(Duration::from_secs(10)).await;  // [TEMP]: Simulate ML model processing

    log::debug!("Saving file to: {}", &file_path);
    let mut file_buffer = form.file.open().await.unwrap();
    match bucket.put_object_stream(&mut file_buffer, &file_path).await {
        Ok(_) => {
            log::debug!("Data sent to S3.");
            locks::image_upload::unlock(&file_path, &pool).await.unwrap();
        },
        Err(e) => {
            log::error!("Failed to send data to S3: {}", e);
            locks::image_upload::unlock(&file_path, &pool).await.unwrap();
            return status::Custom(
                Status::InternalServerError,
                Json(UploadImageResponse {
                    is_stored: true,
                    is_accepted: false,
                    is_ml_processed: None,
                    tags: Some(form.tags.clone().unwrap_or_default()),  // TODO: Should be pulled from ClickHouse (or response from ML)
                    filename: None,
                    error: Some(format!("Failed to save file: {}", e))
                }
            ));
        }
    };

    log::info!("Sending processing task for worker to RSMQ...");
    let worker_queue_msg_id = match rsmq.inner().clone().send_message(
        RsmqDsQueue::BackendWorker.as_str(),
        serde_json::to_string(&TaskType::CompressImage {
            filename: file_name.clone()
        }).unwrap().as_str(),
        None
    ).await {
        Ok(msg) => msg,
        Err(e) => {
            log::error!("Failed to send message to RSMQ: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(UploadImageResponse {
                    is_stored: true,
                    is_accepted: true,
                    is_ml_processed: Some(false),
                    tags: Some(form.tags.clone().unwrap_or_default()),
                    filename: Some(file_name),
                    error: Some(format!("Failed to send message to RSMQ: {}", e))
                }
            ));
        }
    };

    log::info!("Sent processing task for worker to RSMQ: {:?}", worker_queue_msg_id);

    status::Custom(
        Status::Ok,
        Json(UploadImageResponse {
            is_stored: true,
            is_accepted: true,
            is_ml_processed: None,
            tags: Some(form.tags.clone().unwrap_or_default()),  // TODO: Should be pulled from ClickHouse (or response from ML)
            filename: Some(file_name),
            error: None
        }
    ))
}

#[delete("/delete/<file_name>")]
async fn delete_image(
    file_name: &str,
    bucket: &rocket::State<Bucket>,
    pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>
) -> status::Custom<Json<DeleteImageResponse>> {
    log::debug!("Deleting image: {}", file_name);

    let file_path = file_name.to_string();
    let s3_image_exists = match get_img(&file_path, &bucket).await {
        Some(_) => true,
        None => false
    };

    // Check if the file exists
    match s3_image_exists {
        true => (),
        false => {
            log::error!("File does not exist: {}", &file_path);
            return status::Custom(
                Status::NotFound,
                Json(DeleteImageResponse {
                    is_deleted: false,
                    error: Some("File does not exist.".into())
                }
            ));
        }
    }

    // Check for image lock
    let is_locked = match locks::image_upload::check(&file_path, &pool)
        .await {
            Ok(locked) => locked,
            Err(e) => {
                log::error!("Failed to check image lock: {}", e);
                return status::Custom(
                    Status::InternalServerError,
                    Json(DeleteImageResponse {
                        is_deleted: false,
                        error: Some(format!("Failed to check image lock: {}", e))
                    }
                ));
            }
        };

    if is_locked {
        log::error!("Image is locked: {}", &file_path);
        return status::Custom(
            Status::Locked,
            Json(DeleteImageResponse {
                is_deleted: false,
                error: Some("Image is locked.".into())
            }
        ));
    }

    // Lock the image
    match locks::image_upload::lock(&file_path, &pool).await {
        Ok(_) => (),
        Err(e) => {
            log::error!("Failed to lock image: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(DeleteImageResponse {
                    is_deleted: false,
                    error: Some(format!("Failed to lock image: {}", e))
                }
            ));
        }
    };

    match bucket.delete_object(&file_path).await {
        Ok(_) => {
            log::debug!("File deleted: {}", &file_path);
            locks::image_upload::unlock(&file_path, &pool).await.unwrap();
            return status::Custom(
                Status::Ok,
                Json(DeleteImageResponse {
                    is_deleted: true,
                    error: None
                }
            ));
        },
        Err(e) => {
            log::error!("Failed to delete file: {}", e);
            locks::image_upload::unlock(&file_path, &pool).await.unwrap();
            return status::Custom(
                Status::InternalServerError,
                Json(DeleteImageResponse {
                    is_deleted: false,
                    error: Some(format!("Failed to delete file: {}", e))
                })
            );
        }
    };
}
