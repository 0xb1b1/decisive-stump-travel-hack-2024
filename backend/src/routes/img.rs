use rocket::{
    serde::json::Json, form::Form,
    http::Status,
    response::status,
};
use rocket::http::{
    ContentType,
    MediaType
};
// use async_std::task;
// use cors::*;
// use std::env;
use log;
use s3::Bucket;
use std::path;  // time::Duration
use std::fs;
use crate::models::uploads::{
    UploadImage,
    UploadImageResponse
};
use crate::utils::s3::images::get_img;

pub fn routes() -> Vec<rocket::Route> {
    routes![
        upload_image
    ]
}

#[post("/upload", format = "multipart/form-data", data = "<form>")]
async fn upload_image(
    form: Form<UploadImage<'_>>,
    bucket: &rocket::State<Bucket>
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
                tags: Some(form.tags.clone().unwrap_or_default()),
                filename: None,
                error: Some("Unsupported file type.".into())
            }
        ));
    }

    // Create a proper file path
    let file_name: String;
    let file_path: String;
    {
        let media_type: &MediaType = file_type.media_type();
        let file_hash = crate::utils::hash::hash_file(
            &mut fs::File::open(
                path::Path::new(&form.file.path().unwrap())
            ).unwrap());
        file_name = format!("{}.{}", file_hash, media_type.sub());
        file_path = file_name.clone();  // For flexibility
        log::debug!("File will be saved in S3 as {}", &file_path);
    }

    // Check if the file already exists
    match get_img(&file_path, &bucket).await {
        Some(_) => {
            log::error!("File already exists: {}", &file_path);
            return status::Custom(
                Status::Conflict,
                Json(UploadImageResponse {
                    is_stored: true,
                    is_accepted: false,
                    tags: Some(form.tags.clone().unwrap_or_default()),  // TODO: Should be pulled from ClickHouse
                    filename: Some(file_name.clone()),
                    error: Some("File already exists.".into())
                }
            ));
        },
        None => ()
    }

    // The following is done via a separate request
    // task::sleep(Duration::from_secs(10)).await;  // [TEMP]: Simulate ML model processing

    // Ensure that the file wasn't processed while we were waiting for ML
    match get_img(&file_path, &bucket).await {
        Some(_) => {  // TODO: What happens to tags in this scenario? Ask ML
            log::error!("ML already processed the image (race): {}", &file_path);
            return status::Custom(
                Status::Conflict,
                Json(UploadImageResponse {  // TODO: Remove repetitive code.
                    is_stored: true,
                    is_accepted: false,
                    tags: Some(form.tags.clone().unwrap_or_default()),  // TODO: Should be pulled from ClickHouse
                    filename: Some(file_name.clone()),
                    error: Some("Race condition detected, aborting.".into())
                }
            ));
        },
        None => ()
    }

    log::debug!("Saving file to: {}", &file_path);
    let mut file_buffer = form.file.open().await.unwrap();
    match bucket.put_object_stream(&mut file_buffer, &file_path).await {
        Ok(_) => {
            log::debug!("Data sent to S3.");
            return status::Custom(
                Status::Ok,
                Json(UploadImageResponse {
                    is_stored: true,
                    is_accepted: true,
                    tags: Some(form.tags.clone().unwrap_or_default()),  // TODO: Should be pulled from ClickHouse (or response from ML)
                    filename: Some(file_name),
                    error: None
                }
            ));
        },
        Err(e) => {
            log::error!("Failed to send data to S3: {}", e);
            // Return status code 500
            return status::Custom(
                Status::InternalServerError,
                Json(UploadImageResponse {
                    is_stored: true,
                    is_accepted: false,
                    tags: Some(form.tags.clone().unwrap_or_default()),  // TODO: Should be pulled from ClickHouse (or response from ML)
                    filename: None,
                    error: Some(format!("Failed to save file: {}", e))
                }
            ));
        }
    };
}
