use serde::Serialize;
use rocket::fs::TempFile;

#[derive(FromForm)]
pub struct UploadFile<'f> {
    pub file: TempFile<'f>
}

#[derive(Serialize)]
pub struct UploadFileResponse {
    pub is_stored: bool,  // File is stored (whether it was uploaded or already existed)
    pub is_accepted: bool,  // File is accepted (whether the upload succeeded)
    pub filename: Option<String>,
    pub error: Option<String>
}
