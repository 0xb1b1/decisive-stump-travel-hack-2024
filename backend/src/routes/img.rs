use rocket::{
    serde::json::Json, form::Form
    // State, data::{Limits, ToByteUnit}
};
use rocket::http::{
    ContentType,
    MediaType
};
use async_std::task;
// use cors::*;
// use std::env;
use log;
use std::{path, time::Duration};
use std::fs;
use crate::models::uploads;

mod utils;

pub fn routes() -> Vec<rocket::Route> {
    routes![
        upload_image
    ]
}

#[post("/upload", format = "multipart/form-data", data = "<form>")]
async fn upload_image(mut form: Form<uploads::UploadFile<'_>>) -> Json<uploads::UploadFileResponse> {  // UploadFileResponse
    log::debug!("Got a file: {:?}", form.file);

    let file_type: &ContentType = match form.file.content_type() {
        Some(t) => t,
        None => {
            log::error!("Failed to get file type.");
            return Json(uploads::UploadFileResponse {
                is_stored: false,
                is_accepted: false,
                filename: None,
                error: Some("Failed to get file type.".into())
            });
        }
    };
    // Reject non-image files
    if !file_type.is_jpeg() && !file_type.is_png() {
        log::error!("Invalid file type: {:?}", file_type);
        return Json(uploads::UploadFileResponse {
            is_stored: false,  // File is definitely not stored since it's not an image
            is_accepted: false,
            filename: None,
            error: Some("Invalid file type.".into())
        });
    }

    // Create a proper file path
    let file_name: String;
    let file_path: path::PathBuf;
    {
        let media_type: &MediaType = file_type.media_type();
        let file_hash = crate::utils::hash::hash_file(
            &mut fs::File::open(
                path::Path::new(&form.file.path().unwrap())
            ).unwrap());
        file_name = format!("{}.{}", file_hash, media_type.sub());
        file_path = path::Path::new(UPLOAD_DIR).join(&file_name);
        log::debug!("File will be saved as {}", file_path.as_path().display());
    }

    // Upload directory for the file
    const UPLOAD_DIR: &str = "./uploads/";
    if !path::Path::new(UPLOAD_DIR).exists() {
        fs::create_dir(UPLOAD_DIR).unwrap();
    }

    // Check if the file already exists
    match utils::s3_checks::return_image_stored(&file_path) {
        Some(response) => {
            log::error!("File already exists: {}", file_path.as_path().display());
            return response;
        },
        None => ()
    }

    task::sleep(Duration::from_secs(10)).await;  // [TEMP]: Simulate ML model processing

    // Ensure that the file wasn't processed while we were waiting for ML
    match utils::s3_checks::return_image_stored(&file_path) {
        Some(response) => {
            log::error!("File already exists: {}", file_path.as_path().display());
            return response;
        },
        None => ()
    }

    log::debug!("Saving file to: {}", file_path.as_path().display());
    match form.file.persist_to(path::Path::new(&file_path)).await {
        Ok(_) => {
            println!("File saved.");
            return Json(uploads::UploadFileResponse {
                is_stored: true,
                is_accepted: true,
                filename: Some(file_name),
                error: None
            });
        },
        Err(e) => {
            println!("Failed to save file: {}", e);
            return Json(uploads::UploadFileResponse {
                is_stored: match utils::s3_checks::return_image_stored(&file_path) {
                    Some(_) => true,
                    None => false
                },
                is_accepted: false,
                filename: None,
                error: Some(format!("Failed to save file: {}", e))
            });
        }
    }
}
