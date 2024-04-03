use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct ImageInfo {
    pub filename: String,
    pub s3_presigned_url: Option<String>,
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

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct ImageInfoGallery {
    pub filename: String,
    pub s3_presigned_url: Option<String>,
    pub label: Option<String>,
    pub tags: Option<Vec<String>>,
    pub error: Option<String>,
}
