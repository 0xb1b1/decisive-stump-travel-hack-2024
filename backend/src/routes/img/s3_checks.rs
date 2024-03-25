use std::path;
use rocket::serde::json::Json;
use crate::routes::img::uploads::UploadFileResponse;

pub fn return_image_stored(file_path: &path::PathBuf) -> Option<Json<UploadFileResponse>> {
    match path::Path::new(file_path).exists() {
        true => {
            Some(Json(crate::routes::img::uploads::UploadFileResponse {
                is_stored: true,
                is_accepted: false,
                filename: Some(file_path.file_name().unwrap().to_str().unwrap().to_string()),
                error: Some("File already exists.".into())
            }))
        },
        false => None
    }
}
