use rocket::form::{Form, FromForm};
use rocket::fs::TempFile;
use serde::{Deserialize, Serialize};

use super::images::ImageInfo;

#[derive(FromForm)]
pub struct UploadImage<'f> {
    pub file: TempFile<'f>,
    pub force: Option<bool>,
    pub label: Option<String>,
    pub tags: Option<Vec<String>>,
    pub time_of_day: Option<String>,
    pub weather: Option<String>,
    pub atmosphere: Option<String>,
    pub season: Option<String>,
    pub number_of_people: Option<u8>,
    pub main_color: Option<String>,
    pub orientation: Option<String>,
    pub landmark: Option<String>,
    pub grayscale: Option<bool>,
    pub error: Option<String>,
}
impl UploadImage<'_> {
    // TODO: Optimize this?
    pub fn to_image_info(&self, filename: &str) -> ImageInfo {
        ImageInfo {
            filename: filename.to_string(),
            s3_presigned_urls: None,
            tags: self.tags.clone(),
            label: self.label.clone(),
            time_of_day: self.time_of_day.clone(),
            weather: self.weather.clone(),
            atmosphere: self.atmosphere.clone(),
            season: self.season.clone(),
            number_of_people: self.number_of_people,
            main_color: self.main_color.clone(),
            orientation: self.orientation.clone(),
            landmark: self.landmark.clone(),
            grayscale: self.grayscale,
            view_count: None,
            download_count: None,
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
    pub time_of_day: Option<String>,
    pub weather: Option<String>,
    pub atmosphere: Option<String>,
    pub season: Option<String>,
    pub number_of_people: Option<u8>,
    pub main_color: Option<String>,
    pub orientation: Option<String>,
    pub landmark: Option<String>,
    pub grayscale: Option<bool>,
    pub error: Option<String>,
}
impl UploadImageResponse {
    pub fn from_form<'f>(
        form: &Form<UploadImage<'f>>,
        is_stored: bool,
        is_accepted: bool,
    ) -> UploadImageResponse {
        UploadImageResponse {
            is_stored: is_stored,
            is_accepted: is_accepted,
            filename: None,
            label: form.label.clone(),
            tags: form.tags.clone(),
            time_of_day: form.time_of_day.clone(),
            weather: form.weather.clone(),
            atmosphere: form.atmosphere.clone(),
            season: form.season.clone(),
            number_of_people: form.number_of_people,
            main_color: form.main_color.clone(),
            orientation: form.orientation.clone(),
            landmark: form.landmark.clone(),
            grayscale: form.grayscale,
            error: form.error.clone(),
        }
    }
}

#[derive(Serialize, Deserialize, Clone)]
pub struct PublishImage {
    pub filename: String,
    pub label: Option<String>,
    pub tags: Option<Vec<String>>,
    pub time_of_day: Option<String>,
    pub weather: Option<String>,
    pub atmosphere: Option<String>,
    pub season: Option<String>,
    pub number_of_people: Option<u8>,
    pub main_color: Option<String>,
    pub orientation: Option<String>,
    pub landmark: Option<String>,
    pub grayscale: Option<bool>,
    pub error: Option<String>,
}
impl PublishImage {
    pub fn to_image_info(&self) -> ImageInfo {
        ImageInfo {
            filename: self.filename.clone(),
            s3_presigned_urls: None,
            tags: self.tags.clone(),
            label: self.label.clone(),
            time_of_day: self.time_of_day.clone(),
            weather: self.weather.clone(),
            atmosphere: self.atmosphere.clone(),
            season: self.season.clone(),
            number_of_people: self.number_of_people,
            main_color: self.main_color.clone(),
            orientation: self.orientation.clone(),
            landmark: self.landmark.clone(),
            grayscale: self.grayscale,
            view_count: None,
            download_count: None,
            error: None,
        }
    }
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ImageStatusResponse {
    pub filename: String,
    pub image_info: Option<ImageInfo>,
    pub is_ml_uploaded: Option<bool>,
    pub is_ml_published: Option<bool>,
    pub duplicate_filename: Option<String>,
    pub error: Option<String>,
}
impl ImageStatusResponse {
    pub fn new(filename: &str) -> ImageStatusResponse {
        ImageStatusResponse {
            filename: filename.to_string(),
            is_ml_uploaded: None,
            is_ml_published: None,
            image_info: None,
            duplicate_filename: None,
            error: None,
        }
    }
}

#[derive(Serialize)]
pub struct DeleteImageResponse {
    pub is_deletion_pending: bool,
    pub error: Option<String>,
}
