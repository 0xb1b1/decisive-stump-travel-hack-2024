use serde::Serialize;
use rocket::fs::TempFile;
use rocket::form::FromForm;

use super::images::ImageInfo;

#[derive(FromForm)]
pub struct UploadImage<'f> {
    pub file: TempFile<'f>,
    pub label: Option<String>,
    pub tags: Option<Vec<String>>,
    pub time_of_day: Option<String>,  // TODO: Should be verified by crate::enums::images::TimeOfDay
    pub atmosphere: Option<String>,  // TODO: Should be verified by crate::enums::images::Atmosphere
    pub season: Option<String>,  // TODO: Should be verified by crate::enums::images::Season
    pub number_of_people: Option<u32>,
    pub main_color: Option<String>,  // TODO: Should be verified by crate::enums::images::MainColor
    pub landmark: Option<String>
}
impl UploadImage<'_>{
    pub fn to_image_info(&self, filename: &str) -> ImageInfo {
        ImageInfo {
            filename: filename.to_string(),
            s3_presigned_url: None,
            tags: self.tags.clone(),
            label: self.label.clone(),
            time_of_day: self.time_of_day.clone(),
            atmosphere: self.atmosphere.clone(),
            season: self.season.clone(),
            number_of_people: self.number_of_people,
            main_color: self.main_color.clone(),
            landmark: self.landmark.clone(),
            error: None
        }
    }
}

#[derive(Serialize)]
pub struct UploadImageResponse {
    pub is_stored: bool,  // File is stored (whether it was uploaded or already existed)
    pub is_accepted: bool,  // File is accepted (whether the upload succeeded)
    pub label: Option<String>,
    pub tags: Option<Vec<String>>,
    pub time_of_day: Option<String>,
    pub atmosphere: Option<String>,
    pub season: Option<String>,
    pub number_of_people: Option<u32>,
    pub main_color: Option<String>,
    pub landmark: Option<String>,
    pub filename: Option<String>,
    pub error: Option<String>
}

#[derive(Serialize)]
pub struct DeleteImageResponse {
    pub is_deletion_pending: bool,
    pub error: Option<String>
}
