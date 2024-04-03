use rocket::form::FromForm;
use rocket::fs::TempFile;
use serde::Serialize;

use super::images::ImageInfo;

#[derive(FromForm)]
pub struct UploadImage<'f> {
    pub file: TempFile<'f>,
    pub label: Option<String>,
    pub tags: Option<Vec<String>>,
    pub time_of_day: Option<Vec<String>>,
    pub weather: Option<Vec<String>>,
    pub atmosphere: Option<Vec<String>>,
    pub season: Option<Vec<String>>,
    pub number_of_people: Option<u8>,
    pub colors: Option<Vec<String>>,
    pub landmark: Option<String>,
    pub grayscale: Option<bool>,
    pub error: Option<String>,
}
impl UploadImage<'_> {
    pub fn to_image_info(&self, filename: &str) -> ImageInfo {
        ImageInfo {
            filename: filename.to_string(),
            s3_presigned_url: None,
            tags: self.tags.clone(),
            label: self.label.clone(),
            time_of_day: self.time_of_day.clone(),
            weather: self.weather.clone(),
            atmosphere: self.atmosphere.clone(),
            season: self.season.clone(),
            number_of_people: self.number_of_people,
            colors: self.colors.clone(),
            landmark: self.landmark.clone(),
            grayscale: self.grayscale,
            error: None,
        }
    }
}

#[derive(Serialize)]
pub struct UploadImageResponse {
    pub is_stored: bool, // File is stored (whether it was uploaded or already existed)
    pub is_accepted: bool, // File is accepted (whether the upload succeeded)
    pub filename: Option<String>,
    pub label: Option<String>,
    pub tags: Option<Vec<String>>,
    pub time_of_day: Option<Vec<String>>,
    pub weather: Option<Vec<String>>,
    pub atmosphere: Option<Vec<String>>,
    pub season: Option<Vec<String>>,
    pub number_of_people: Option<u8>,
    pub colors: Option<Vec<String>>,
    pub landmark: Option<String>,
    pub grayscale: Option<bool>,
    pub error: Option<String>,
}

#[derive(Serialize)]
pub struct DeleteImageResponse {
    pub is_deletion_pending: bool,
    pub error: Option<String>,
}
