use serde::Serialize;
use rocket::fs::TempFile;

#[derive(FromForm)]
pub struct UploadImage<'f> {
    pub file: TempFile<'f>,
    pub tags: Option<Vec<String>>
}

#[derive(Serialize)]
pub struct UploadImageResponse {
    pub is_stored: bool,  // File is stored (whether it was uploaded or already existed)
    pub is_accepted: bool,  // File is accepted (whether the upload succeeded)
    pub tags: Option<Vec<String>>,  // TODO: Enforce after ML integration
    pub filename: Option<String>,
    pub error: Option<String>
}
