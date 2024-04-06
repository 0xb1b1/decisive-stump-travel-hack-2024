use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct S3PresignedUrls {
    pub normal: Option<String>,
    pub comp: Option<String>,
    pub thumb: Option<String>,
}
impl S3PresignedUrls {
    pub fn new() -> Self {
        S3PresignedUrls {
            normal: None,
            comp: None,
            thumb: None,
        }
    }
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct ImageInfo {
    pub filename: String,
    pub s3_presigned_urls: Option<S3PresignedUrls>,
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
    pub view_count: Option<u32>,
    pub download_count: Option<u32>,
    pub error: Option<String>,
}
impl ImageInfo {
    pub fn new(filename: &str) -> Self {
        ImageInfo {
            filename: String::from(filename),
            s3_presigned_urls: None,
            label: None,
            tags: None,
            time_of_day: None,
            weather: None,
            atmosphere: None,
            season: None,
            number_of_people: None,
            main_color: None,
            orientation: None,
            landmark: None,
            grayscale: None,
            view_count: None,
            download_count: None,
            error: None,
        }
    }
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct ImageInfoGallery {
    pub filename: String,
    pub s3_presigned_urls: Option<S3PresignedUrls>,
    pub label: Option<String>,
    pub tags: Option<Vec<String>>,
    pub error: Option<String>,
}
