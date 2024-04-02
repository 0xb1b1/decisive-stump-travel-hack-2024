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

use crate::enums::rsmq::RsmqDsQueue;
use crate::enums::worker::TaskType;
use crate::models::http::images::ImageInfo;
use crate::models::http::uploads::{
    DeleteImageResponse,
    UploadImage,
    UploadImageResponse
};
use crate::utils::s3::images::get_img;
use crate::{locks, utils};

pub fn routes() -> Vec<rocket::Route> {
    routes![
        upload_image,
        delete_image,
        // get_image_list,
        get_image_full
    ]
}

#[post("/upload", format = "multipart/form-data", data = "<form>")]
async fn upload_image(
    form: Form<UploadImage<'_>>,
    bucket: &rocket::State<Bucket>,
    redis_pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
    rsmq_pool: &rocket::State<PooledRsmq>
) -> status::Custom<Json<UploadImageResponse>> {
    {
        let filename = match form.file.name() {
            Some(name) => name,
            None => {
                log::error!("Failed to get file name.");
                return status::Custom(
                    Status::BadRequest,
                    Json(UploadImageResponse {
                        is_stored: false,
                        is_accepted: false,
                        label: form.label.clone(),
                        tags: form.tags.clone(),
                        time_of_day: form.time_of_day.clone(),
                        atmosphere: form.atmosphere.clone(),
                        season: form.season.clone(),
                        number_of_people: form.number_of_people.clone(),
                        main_color: form.main_color.clone(),
                        landmark: form.landmark.clone(),
                        filename: None,
                        error: Some("Failed to get file name.".into())
                    }
                ));
            }
        };

        log::debug!("Got an image: ({})", filename);
    }
    match &form.tags {
        Some(tags) => log::debug!("Image tags: {:?}", tags),
        None => log::debug!("No tags provided.")  // TODO: remove tags from uploads entirely.
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
                    label: form.label.clone(),
                    tags: form.tags.clone(),
                    time_of_day: form.time_of_day.clone(),
                    atmosphere: form.atmosphere.clone(),
                    season: form.season.clone(),
                    number_of_people: form.number_of_people.clone(),
                    main_color: form.main_color.clone(),
                    landmark: form.landmark.clone(),
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
                label: form.label.clone(),
                tags: form.tags.clone(),
                time_of_day: form.time_of_day.clone(),
                atmosphere: form.atmosphere.clone(),
                season: form.season.clone(),
                number_of_people: form.number_of_people.clone(),
                main_color: form.main_color.clone(),
                landmark: form.landmark.clone(),
                filename: None,
                error: Some("Unsupported file type.".into())
            }
        ));
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
        let file_hash = crate::utils::hash::hash_file(
            &contents
        );

        let file_ext;
        if media_type.sub() == "jpeg" {
            file_ext = "jpg";
        } else {
            file_ext = media_type.sub().as_str();
        }

        file_name = format!("{}.{}", file_hash, file_ext);
        file_path = file_name.clone();  // For flexibility
        log::info!("File will be saved in S3 as {}", &file_path);
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
                    label: form.label.clone(),
                    tags: form.tags.clone(),
                    time_of_day: form.time_of_day.clone(),
                    atmosphere: form.atmosphere.clone(),
                    season: form.season.clone(),
                    number_of_people: form.number_of_people.clone(),
                    main_color: form.main_color.clone(),
                    landmark: form.landmark.clone(),
                    filename: Some(file_name.clone()),
                    error: Some("File already exists.".into())
                }
            ));
        },
        false => ()
    }

    // Check for image lock
    let is_locked = match locks::image_upload::check(&file_path, &redis_pool)
        .await {
            Ok(locked) => locked,
            Err(e) => {
                log::error!("Failed to check image lock: {}", e);
                return status::Custom(
                    Status::InternalServerError,
                    Json(UploadImageResponse {
                        is_stored: false,
                        is_accepted: false,
                        label: form.label.clone(),
                        tags: form.tags.clone(),
                        time_of_day: form.time_of_day.clone(),
                        atmosphere: form.atmosphere.clone(),
                        season: form.season.clone(),
                        number_of_people: form.number_of_people.clone(),
                        main_color: form.main_color.clone(),
                        landmark: form.landmark.clone(),
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
                is_accepted: false,  // TODO: Should be pulled from ClickHouse
                label: form.label.clone(),
                tags: form.tags.clone(),
                time_of_day: form.time_of_day.clone(),
                atmosphere: form.atmosphere.clone(),
                season: form.season.clone(),
                number_of_people: form.number_of_people.clone(),
                main_color: form.main_color.clone(),
                landmark: form.landmark.clone(),
                filename: None,
                error: Some("Image is locked.".into())
            }
        ));
    }

    // Lock the image
    match locks::image_upload::lock(&file_path, &redis_pool).await {
        Ok(_) => (),
        Err(e) => {
            log::error!("Failed to lock image: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(UploadImageResponse {
                    is_stored: false,
                    is_accepted: false,
                    label: form.label.clone(),
                    tags: form.tags.clone(),
                    time_of_day: form.time_of_day.clone(),
                    atmosphere: form.atmosphere.clone(),
                    season: form.season.clone(),
                    number_of_people: form.number_of_people.clone(),
                    main_color: form.main_color.clone(),
                    landmark: form.landmark.clone(),
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
            locks::image_upload::unlock(&file_path, &redis_pool).await.unwrap();
        },
        Err(e) => {
            log::error!("Failed to send data to S3: {}", e);
            locks::image_upload::unlock(&file_path, &redis_pool).await.unwrap();
            return status::Custom(
                Status::InternalServerError,
                Json(UploadImageResponse {
                    is_stored: true,
                    is_accepted: false,
                    label: form.label.clone(),
                    tags: form.tags.clone(),
                    time_of_day: form.time_of_day.clone(),
                    atmosphere: form.atmosphere.clone(),
                    season: form.season.clone(),
                    number_of_people: form.number_of_people.clone(),
                    main_color: form.main_color.clone(),
                    landmark: form.landmark.clone(),
                    filename: None,
                    error: Some(format!("Failed to save file: {}", e))
                }
            ));
        }
    };

    log::info!("Setting image info in Redis...");
    match utils::redis::images::set_image_info(
        // Get the object in form and use .to_image_info() to convert it to ImageInfo
        &form.to_image_info(&file_name),
        &redis_pool
    ).await {
        Ok(_) => (),
        Err(e) => {
            log::error!("Failed to set image info in Redis: {}", e);
            locks::image_upload::unlock(&file_path, &redis_pool).await.unwrap();
            return status::Custom(
                Status::InternalServerError,
                Json(UploadImageResponse {
                    is_stored: true,
                    is_accepted: true,
                    label: form.label.clone(),
                    tags: form.tags.clone(),
                    time_of_day: form.time_of_day.clone(),
                    atmosphere: form.atmosphere.clone(),
                    season: form.season.clone(),
                    number_of_people: form.number_of_people.clone(),
                    main_color: form.main_color.clone(),
                    landmark: form.landmark.clone(),
                    filename: Some(file_name),
                    error: Some(format!("Failed to set image info in Redis: {}", e))
                }
            ));
        }
    }

    log::info!("Sending processing task for worker to RSMQ...");
    let worker_queue_msg_id = match rsmq_pool.inner().clone().send_message(
        RsmqDsQueue::BackendWorker.as_str(),
        serde_json::to_string(&TaskType::CompressImage {
            filename: file_name.clone()
        }).unwrap().as_str(),
        None
    ).await {
        Ok(msg) => msg,
        Err(e) => {
            log::error!("Failed to send message to RSMQ: {}", e);
            locks::image_upload::unlock(&file_path, &redis_pool).await.unwrap();
            return status::Custom(
                Status::InternalServerError,
                Json(UploadImageResponse {
                    is_stored: true,
                    is_accepted: true,
                    label: form.label.clone(),
                    tags: form.tags.clone(),
                    time_of_day: form.time_of_day.clone(),
                    atmosphere: form.atmosphere.clone(),
                    season: form.season.clone(),
                    number_of_people: form.number_of_people.clone(),
                    main_color: form.main_color.clone(),
                    landmark: form.landmark.clone(),
                    filename: Some(file_name),
                    error: Some(format!("Failed to send message to RSMQ: {}", e))
                }
            ));
        }
    };
    log::info!("Sent processing task for worker to RSMQ: {:?}", worker_queue_msg_id);

    locks::image_upload::unlock(&file_path, &redis_pool).await.unwrap();

    status::Custom(
        Status::Ok,
        Json(UploadImageResponse {
            is_stored: true,
            is_accepted: true,
            label: form.label.clone(),
            tags: form.tags.clone(),
            time_of_day: form.time_of_day.clone(),
            atmosphere: form.atmosphere.clone(),
            season: form.season.clone(),
            number_of_people: form.number_of_people.clone(),
            main_color: form.main_color.clone(),
            landmark: form.landmark.clone(),
            filename: Some(file_name),
            error: None
        }
    ))
}

#[delete("/delete/<file_name>")]
async fn delete_image(
    file_name: &str,
    bucket: &rocket::State<Bucket>,
    redis_pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
    rsmq: &rocket::State<PooledRsmq>
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
                    is_deletion_pending: false,
                    error: Some("File does not exist.".into())
                }
            ));
        }
    }

    // Check for image lock
    let is_locked = match locks::image_upload::check(&file_path, &redis_pool)
        .await {
            Ok(locked) => locked,
            Err(e) => {
                log::error!("Failed to check image lock: {}", e);
                return status::Custom(
                    Status::InternalServerError,
                    Json(DeleteImageResponse {
                        is_deletion_pending: false,
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
                is_deletion_pending: false,
                error: Some("Image is locked.".into())
            }
        ));
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
                    error: Some(format!("Failed to lock image: {}", e))
                }
            ));
        }
    };

    log::debug!("Sending deletion task for worker to RSMQ...");
    let worker_queue_msg_id = match rsmq.inner().clone().send_message(
        RsmqDsQueue::BackendWorker.as_str(),
        serde_json::to_string(&TaskType::DeleteImage {
            filename: file_name.to_string()
        }).unwrap().as_str(),
        None
    ).await {
        Ok(msg) => msg,
        Err(e) => {
            log::error!("Failed to send message to RSMQ: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(DeleteImageResponse {
                    is_deletion_pending: false,
                    error: Some(format!("Failed to send message to RSMQ: {}", e))
                }
            ));
        }
    };
    log::info!("Sent deletion task for worker to RSMQ: {:?}", worker_queue_msg_id);

    status::Custom(
        Status::Ok,
        Json(DeleteImageResponse {
            is_deletion_pending: true,
            error: None
        }
    ))
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
    // pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
    bucket: &rocket::State<Bucket>
) -> status::Custom<Json<ImageInfo>> {
    log::debug!("Fetching image: {}", file_name);
    // Get presigned URL
    let s3_presigned_url = match utils::s3::images::get_presigned_url(&file_name, &bucket)
        .await {
            Some(url) => url,
            None => {
                log::error!("Failed to get presigned URL.");
                return status::Custom(
                    Status::InternalServerError,
                    Json(ImageInfo {
                        filename: file_name.to_string(),
                        s3_presigned_url: None,
                        label: None,  // TODO: Add fields!!!!!!
                        tags: None,
                        time_of_day: None,
                        atmosphere: None,
                        season: None,
                        number_of_people: None,
                        main_color: None,
                        landmark: None,
                        error: Some("Failed to get presigned URL.".into())
                    }
                ));
            }
        };

    status::Custom(
        Status::Ok,
        Json(ImageInfo {
            filename: file_name.to_string(),
            s3_presigned_url: Some(s3_presigned_url),
            label: None,  // TODO: Add fields!!!!!!
            tags: None,
            time_of_day: None,
            atmosphere: None,
            season: None,
            number_of_people: None,
            main_color: None,
            landmark: None,
            error: None
        }
    ))
}
