use std::time::Duration;

use async_std::task;
use ds_travel_hack_2024::enums::ml_worker::MlTaskType;
use ds_travel_hack_2024::utils::redis::images::get_s3_presigned_urls;
use log;
use rocket::http::{ContentType, MediaType};
use rocket::{form::Form, http::Status, response::status, serde::json::Json};
use rsmq_async::{PooledRsmq, RsmqConnection};
use s3::Bucket;
use tokio::io::AsyncReadExt; // Required for reading file contents (e.g. .read_to_end())

use ds_travel_hack_2024::enums::{rsmq::RsmqDsQueue, worker::TaskType};
use ds_travel_hack_2024::locks;
use ds_travel_hack_2024::models::http::images::{ImageInfo, S3PresignedUrls};
use ds_travel_hack_2024::models::http::uploads::{
    DeleteImageResponse, ImageStatusResponse, PublishImage, UploadImage, UploadImageResponse
};
use ds_travel_hack_2024::utils;
use ds_travel_hack_2024::utils::s3::images::{get_img, get_presigned_url};

use crate::config::DsConfig;

pub fn routes() -> Vec<rocket::Route> {
    routes![
        upload_image,
        check_image_upload,
        publish_image,
        check_image_publish,
        delete_image,
        get_image_full,
    ]
}

#[post("/upload", format = "multipart/form-data", data = "<form>")]
async fn upload_image(
    form: Form<UploadImage<'_>>,
    bucket: &rocket::State<Bucket>,
    redis_pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
    rsmq_pool: &rocket::State<PooledRsmq>,
) -> status::Custom<Json<UploadImageResponse>> {
    {
        let filename = match form.file.name() {
            Some(name) => name,
            None => {
                log::error!("Failed to get file name.");
                return status::Custom(
                    Status::BadRequest,
                    Json(UploadImageResponse {
                        error: Some("Failed to get file name.".into()),
                        ..UploadImageResponse::from_form(&form, false, false)
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
                Json(UploadImageResponse {
                    error: Some("Failed to get file type.".into()),
                    ..UploadImageResponse::from_form(&form, false, false)
                }),
            );
        }
    };
    // Reject non-image files
    if !file_type.is_jpeg() && !file_type.is_png() {
        log::error!("Invalid file type: {:?}", file_type);
        return status::Custom(
            Status::UnsupportedMediaType,
            Json(UploadImageResponse {
                error: Some("Invalid file type.".into()),
                ..UploadImageResponse::from_form(&form, false, false)
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
        true => {
            log::error!("File already exists: {}", &file_path);
            return status::Custom(
                Status::Conflict,
                Json(UploadImageResponse {
                    filename: Some(file_name.clone()),
                    error: Some("File already exists.".into()),
                    ..UploadImageResponse::from_form(&form, true, false)
                }),
            );
        }
        false => (),
    }

    // Check for image lock
    let is_locked = match locks::image_upload::check(&file_path, &redis_pool).await {
        Ok(locked) => locked,
        Err(e) => {
            log::error!("Failed to check image lock: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(UploadImageResponse {
                    error: Some(format!("Failed to check image lock: {}", e)),
                    ..UploadImageResponse::from_form(&form, false, false)
                }),
            );
        }
    };

    if is_locked {
        log::error!("Image is locked: {}", &file_path);
        return status::Custom(
            Status::Locked,
            Json(UploadImageResponse {
                error: Some("Image is locked.".into()),
                ..UploadImageResponse::from_form(&form, false, false)
            }),
        );
    }

    // Lock the image
    match locks::image_upload::lock(&file_path, &redis_pool).await {
        Ok(_) => (),
        Err(e) => {
            log::error!("Failed to lock image: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(UploadImageResponse {
                    error: Some(format!("Failed to lock image: {}", e)),
                    ..UploadImageResponse::from_form(&form, false, false)
                }),
            );
        }
    };

    // The following is done via a separate request
    // task::sleep(Duration::from_secs(10)).await;  // [TEMP]: Simulate ML model processing

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
                Json(UploadImageResponse {
                    error: Some(format!("Failed to send data to S3: {}", e)),
                    ..UploadImageResponse::from_form(&form, false, false)
                }),
            );
        }
    };

    log::info!("Setting image info in Redis...");
    match utils::redis::images::set_image_info(
        // Get the object in form and use .to_image_info() to convert it to ImageInfo
        &form.to_image_info(&file_name),
        &redis_pool,
    )
    .await
    {
        Ok(_) => (),
        Err(e) => {
            log::error!("Failed to set image info in Redis: {}", e);
            locks::image_upload::unlock(&file_path, &redis_pool)
                .await
                .unwrap();
            // TODO: Delete image from all buckets?
            return status::Custom(
                Status::InternalServerError,
                Json(UploadImageResponse {
                    error: Some(format!("Failed to set image info in Redis: {}", e)),
                    ..UploadImageResponse::from_form(&form, false, false)
                }),
            );
        }
    }

    log::info!("Sending processing task for worker to RSMQ...");
    let worker_queue_msg_id = match rsmq_pool
        .inner()
        .clone()
        .send_message(
            RsmqDsQueue::BackendWorker.as_str(),
            serde_json::to_string(&TaskType::CompressImage {
                filename: file_name.clone(),
            })
            .unwrap()
            .as_str(),
            None,
        )
        .await
    {
        Ok(msg) => msg,
        Err(e) => {
            log::error!("Failed to send message to RSMQ: {}", e);
            locks::image_upload::unlock(&file_path, &redis_pool)
                .await
                .unwrap();
            // TODO: Delete image from all buckets?
            return status::Custom(
                Status::InternalServerError,
                Json(UploadImageResponse {
                    error: Some(format!("Failed to send message to RSMQ: {}", e)),
                    ..UploadImageResponse::from_form(&form, false, false)
                }),
            );
        }
    };
    log::info!(
        "Sent processing task for worker to RSMQ: {:?}",
        worker_queue_msg_id
    );

    locks::image_upload::unlock(&file_path, &redis_pool)
        .await
        .unwrap();

    status::Custom(
        Status::Ok,
        Json(UploadImageResponse {
            filename: Some(file_name),
            ..UploadImageResponse::from_form(&form, true, true)
        }),
    )
}

#[get("/upload/check?<filename>")]
async fn check_image_upload(
    filename: &str,
    bucket: &rocket::State<Bucket>,
    redis_pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
    config: &rocket::State<DsConfig>,
) -> status::Custom<Json<ImageStatusResponse>> {
    log::debug!("Checking image upload status: {}", filename);

    let mut conn = match redis_pool.get().await {
        Ok(conn) => conn,
        Err(e) => {
            log::error!("Failed to get connection from Redis pool: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(ImageStatusResponse {
                    is_ml_uploaded: None,
                    ..ImageStatusResponse::new(filename)
                }),
            );
        }
    };

    let mut timeout_counter = 0;
    loop {
        if timeout_counter >= config.upload_check_retries {
            log::error!("Image upload check timed out: {}", filename);
            return status::Custom(
                Status::RequestTimeout,
                Json(ImageStatusResponse {
                    is_ml_uploaded: None,
                    error: Some("Image upload check timed out.".into()),
                    ..ImageStatusResponse::new(filename)
                }),
            );
        }

        let image_exists: bool = redis::cmd("EXISTS")
            .arg(format!("image-info:upload:{}", filename))
            .query_async(&mut *conn)
            .await
            .unwrap();

        if !image_exists {
            log::error!("Image does not exist: {}", filename);
            return status::Custom(
                Status::NotFound,
                Json(ImageStatusResponse {
                    is_ml_uploaded: None,
                    error: Some("Image does not exist (it probably timed out.)".into()),
                    ..ImageStatusResponse::new(filename)
                }),
            );
        } else {
            log::debug!("Image exists: {}", filename);
        }

        let is_ml_uploaded: bool = redis::cmd("EXISTS")
        .arg(format!("images:upload:ready:{}", filename))
        .query_async(&mut *conn)
        .await
        .unwrap();

        if is_ml_uploaded {
            log::debug!("Image is ready: {}", filename);
            log::debug!("Getting presigned URLs from Redis: {}", filename);
            let presigned_urls = S3PresignedUrls {
                normal: get_presigned_url(&filename, &bucket, 360).await,
                comp: None,
                thumb: None,
            };

            log::debug!("Getting image info as generated by ML from Redis...");
            let mut image_info: ImageInfo = match redis::cmd("GET")
                .arg(format!("images:upload:ready:{}", filename))
                .query_async(&mut *redis_pool.get().await.unwrap())
                .await
            {
                Ok(data) => match data {
                    redis::Value::Data(data) => match serde_json::from_slice(&data) {
                        Ok(info) => info,
                        Err(e) => {
                            log::error!("Failed to parse image info: {}", e);
                            return status::Custom(
                                Status::InternalServerError,
                                Json(ImageStatusResponse {
                                    is_ml_uploaded: None,
                                    error: Some(format!("Failed to parse image info: {}", e)),
                                    ..ImageStatusResponse::new(filename)
                                }),
                            );
                        }
                    },
                    _ => {
                        log::error!("Failed to get image info: {:?}", data);
                        return status::Custom(
                            Status::InternalServerError,
                            Json(ImageStatusResponse {
                                is_ml_uploaded: None,
                                error: Some("Failed to get image info.".into()),
                                ..ImageStatusResponse::new(filename)
                            }),
                        );
                    }
                },
                Err(e) => {
                    log::error!("Failed to get image info: {}", e);
                    return status::Custom(
                        Status::InternalServerError,
                        Json(ImageStatusResponse {
                            is_ml_uploaded: None,
                            error: Some(format!("Failed to get image info: {}", e)),
                            ..ImageStatusResponse::new(filename)
                        }),
                    );
                }
            };

            image_info.s3_presigned_urls = Some(presigned_urls);

            return status::Custom(
                Status::Ok,
                Json(ImageStatusResponse {
                    is_ml_uploaded: Some(is_ml_uploaded),
                    image_info: Some(image_info),
                    ..ImageStatusResponse::new(filename)
                }),
            );
        }

        log::debug!(
            "Image is not ready, waiting before trying again: {}",
            filename
        );
        timeout_counter += 1;
        task::sleep(Duration::from_secs(config.upload_check_interval_secs)).await;
    }
}

#[post("/publish", format = "multipart/form-data", data = "<form>")]  // TODO!
async fn publish_image(
    form: Form<PublishImage>,
    rsmq_pool: &rocket::State<PooledRsmq>,
) -> status::Custom<Json<ImageInfo>> {
    let image_info: ImageInfo = form.clone().to_image_info();

    let ml_task = MlTaskType::new(&form.clone().filename.as_str());

    let serialized_ml_task = serde_json::to_string(&ml_task).unwrap();
    log::debug!("Serialized ML task: {}", &serialized_ml_task);

    // Send to RSMQ
    let queue_id = match rsmq_pool.inner().clone().send_message(
        RsmqDsQueue::AnalyzeBackendMl.as_str(),
        serialized_ml_task,
        None,
    ).await {
        Ok(id) => id,
        Err(e) => {
            log::error!("Failed to send message to RSMQ: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(ImageInfo {
                    error: Some(format!("Failed to send message to RSMQ: {}", e)),
                    ..image_info
                }),
            );
        }
    };

    log::info!("Sent message to RSMQ; queue id: {:?}", queue_id);

    status::Custom(Status::Ok, Json(image_info))
}

#[get("/publish/check?<filename>")]
async fn check_image_publish(
    filename: &str,
    bucket: &rocket::State<Bucket>,
    redis_pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
    config: &rocket::State<DsConfig>,
) -> status::Custom<Json<ImageStatusResponse>> {
    log::debug!("Checking image upload status: {}", filename);

    let mut conn = match redis_pool.get().await {
        Ok(conn) => conn,
        Err(e) => {
            log::error!("Failed to get connection from Redis pool: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(ImageStatusResponse {
                    is_ml_uploaded: None,
                    ..ImageStatusResponse::new(filename)
                }),
            );
        }
    };

    let mut timeout_counter = 0;
    loop {
        if timeout_counter >= config.publish_check_retries {
            log::error!("Image upload check timed out: {}", filename);
            return status::Custom(
                Status::RequestTimeout,
                Json(ImageStatusResponse {
                    is_ml_uploaded: None,
                    error: Some("Image upload check timed out.".into()),
                    ..ImageStatusResponse::new(filename)
                }),
            );
        }

        let image_exists: bool = redis::cmd("EXISTS")
            .arg(format!("image-info:upload:{}", filename))
            .query_async(&mut *conn)
            .await
            .unwrap();

        if !image_exists {
            log::error!("Image does not exist: {}", filename);
            return status::Custom(
                Status::NotFound,
                Json(ImageStatusResponse {
                    is_ml_uploaded: None,
                    error: Some("Image does not exist (it probably timed out.)".into()),
                    ..ImageStatusResponse::new(filename)
                }),
            );
        } else {
            log::debug!("Image exists: {}", filename);
        }

        let is_ml_uploaded: bool = redis::cmd("EXISTS")
        .arg(format!("images:publish:ready:{}", filename))
        .query_async(&mut *conn)
        .await
        .unwrap();

        if is_ml_uploaded {
            log::debug!("Image is ready: {}", filename);
            log::debug!("Getting presigned URLs from Redis: {}", filename);
            let presigned_urls = S3PresignedUrls {
                normal: get_presigned_url(&filename, &bucket, 360).await,
                comp: None,
                thumb: None,
            };

            log::debug!("Getting image info as generated by ML from Redis...");
            let mut image_info: ImageInfo = match redis::cmd("GET")
                .arg(format!("images:publish:ready:{}", filename))
                .query_async(&mut *redis_pool.get().await.unwrap())
                .await
            {
                Ok(data) => match data {
                    redis::Value::Data(data) => match serde_json::from_slice(&data) {
                        Ok(info) => info,
                        Err(e) => {
                            log::error!("Failed to parse image info: {}", e);
                            return status::Custom(
                                Status::InternalServerError,
                                Json(ImageStatusResponse {
                                    is_ml_uploaded: None,
                                    error: Some(format!("Failed to parse image info: {}", e)),
                                    ..ImageStatusResponse::new(filename)
                                }),
                            );
                        }
                    },
                    _ => {
                        log::error!("Failed to get image info: {:?}", data);
                        return status::Custom(
                            Status::InternalServerError,
                            Json(ImageStatusResponse {
                                is_ml_uploaded: None,
                                error: Some("Failed to get image info.".into()),
                                ..ImageStatusResponse::new(filename)
                            }),
                        );
                    }
                },
                Err(e) => {
                    log::error!("Failed to get image info: {}", e);
                    return status::Custom(
                        Status::InternalServerError,
                        Json(ImageStatusResponse {
                            is_ml_uploaded: None,
                            error: Some(format!("Failed to get image info: {}", e)),
                            ..ImageStatusResponse::new(filename)
                        }),
                    );
                }
            };
            log::debug!(
                "Removing upload image info from Redis: image-info:upload:{}",
                filename
            );
            let _: () = redis::cmd("DEL")
                .arg(format!("image-info:upload:{}", filename))
                .query_async(&mut *conn)
                .await
                .unwrap();

            image_info.s3_presigned_urls = Some(presigned_urls);

            return status::Custom(
                Status::Ok,
                Json(ImageStatusResponse {
                    is_ml_uploaded: Some(is_ml_uploaded),
                    image_info: Some(image_info),
                    ..ImageStatusResponse::new(filename)
                }),
            );
        }

        log::debug!(
            "Image is not ready, waiting before trying again: {}",
            filename
        );
        timeout_counter += 1;
        task::sleep(Duration::from_secs(config.publish_check_interval_secs)).await;
    }
}

#[delete("/delete?<file_name>")]
async fn delete_image(
    file_name: &str,
    bucket: &rocket::State<Bucket>,
    redis_pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
    rsmq: &rocket::State<PooledRsmq>,
) -> status::Custom<Json<DeleteImageResponse>> {
    log::debug!("Deleting image: {}", file_name);

    let file_path = file_name.to_string();
    let s3_image_exists = match get_img(&file_path, &bucket).await {
        Some(_) => true,
        None => false,
    };

    // Check if the file exists
    match s3_image_exists {
        true => (),
        false => {
            log::error!("File does not exist: {}", &file_path);
            return status::Custom(
                Status::NotFound,
                Json(DeleteImageResponse {
                    is_deletion_pending: false,
                    error: Some("File does not exist.".into()),
                }),
            );
        }
    }

    // Check for image lock
    let is_locked = match locks::image_upload::check(&file_path, &redis_pool).await {
        Ok(locked) => locked,
        Err(e) => {
            log::error!("Failed to check image lock: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(DeleteImageResponse {
                    is_deletion_pending: false,
                    error: Some(format!("Failed to check image lock: {}", e)),
                }),
            );
        }
    };

    if is_locked {
        log::error!("Image is locked: {}", &file_path);
        return status::Custom(
            Status::Locked,
            Json(DeleteImageResponse {
                is_deletion_pending: false,
                error: Some("Image is locked.".into()),
            }),
        );
    }

    // Lock the image
    match locks::image_upload::lock(&file_path, &redis_pool).await {
        Ok(_) => (),
        Err(e) => {
            log::error!("Failed to lock image: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(DeleteImageResponse {
                    is_deletion_pending: false,
                    error: Some(format!("Failed to lock image: {}", e)),
                }),
            );
        }
    };

    log::debug!("Sending deletion task for worker to RSMQ...");
    let worker_queue_msg_id = match rsmq
        .inner()
        .clone()
        .send_message(
            RsmqDsQueue::BackendWorker.as_str(),
            serde_json::to_string(&TaskType::DeleteImage {
                filename: file_name.to_string(),
            })
            .unwrap()
            .as_str(),
            None,
        )
        .await
    {
        Ok(msg) => msg,
        Err(e) => {
            log::error!("Failed to send message to RSMQ: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(DeleteImageResponse {
                    is_deletion_pending: false,
                    error: Some(format!("Failed to send message to RSMQ: {}", e)),
                }),
            );
        }
    };
    log::info!(
        "Sent deletion task for worker to RSMQ: {:?}",
        worker_queue_msg_id
    );

    status::Custom(
        Status::Ok,
        Json(DeleteImageResponse {
            is_deletion_pending: true,
            error: None,
        }),
    )
}

// #[get("/get/list")]
// async fn get_image_list(
//     // pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
//     bucket: &rocket::State<Bucket>
// ) -> status::Custom<Json<Vec<String>>> {
//     log::debug!("Fetching image list...");

//     // Get list of images
//     let image_list = match utils::s3::images::get_image_list(&bucket)  // TODO: Fix get_image_list
//         .await {
//             Some(list) => list,
//             None => {
//                 log::error!("Failed to get image list.");
//                 return status::Custom(
//                     Status::InternalServerError,
//                     Json(Vec::new())
//                 );
//             }
//         };

//     status::Custom(
//         Status::Ok,
//         Json(image_list)
//     )
// }

// Get image (return S3 presigned url from redis pool)
#[get("/get/full/<file_name>")]
async fn get_image_full(
    file_name: &str,
    redis_pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
    config: &rocket::State<DsConfig>,
) -> status::Custom<Json<ImageInfo>> {
    log::debug!("Getting image info from ML: {}", file_name);
    let client = reqwest::Client::builder()
        .timeout(Duration::from_secs(40))
        .build()
        .unwrap();

    let url = format!("{}/images/info/{}", config.svc_ml_fast, file_name);
    let req_body: &str = "[\"label\", \"tags\", \"filename\"]";

    let image_info: ImageInfo = match client
        .post(&url)
        .body(req_body)
        .header("Content-Type", "application/json")
        .send()
        .await
    {
        Ok(resp) => {
            let resp_body = match resp.text().await {
                Ok(body) => body,
                Err(e) => {
                    log::error!("Failed to get image info: {}", e);
                    return status::Custom(
                        Status::InternalServerError,
                        Json(ImageInfo {
                            error: Some(format!("Failed to get image info: {}", e)),
                            ..ImageInfo::new(file_name)
                        }),
                    );
                }
            };

            match serde_json::from_str(&resp_body) {
                Ok(data) => data,
                Err(e) => {
                    log::error!("Failed to parse image info: {}", e);
                    return status::Custom(
                        Status::InternalServerError,
                        Json(ImageInfo {
                            error: Some(format!("Failed to parse image info: {}", e)),
                            ..ImageInfo::new(file_name)
                        }),
                    );
                }
            }
        }
        Err(e) => {
            log::error!("Failed to get image info: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(ImageInfo {
                    error: Some(format!("Failed to get image info: {}", e)),
                    ..ImageInfo::new(file_name)
                }),
            );
        }
    };

    log::debug!("Getting presigned URLs from Redis: {}", file_name);
    let s3_presigned_urls = match get_s3_presigned_urls(&file_name, &redis_pool).await {
        Ok(urls) => urls,
        Err(e) => {
            log::error!("Failed to get S3 presigned URLs: {}", e);
            return status::Custom(
                // TODO: Should I error here or proceed?
                Status::InternalServerError,
                Json(ImageInfo {
                    error: Some(format!("Failed to get S3 presigned URLs: {}", e)),
                    ..image_info
                }),
            );
        }
    };

    status::Custom(
        Status::Ok,
        Json(ImageInfo {
            s3_presigned_urls: s3_presigned_urls,
            ..image_info
        }),
    )
}
