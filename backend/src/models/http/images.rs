use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct ImageInfo {
    pub filename: String,
    pub s3_presigned_url: Option<String>,
    pub label: Option<String>,
    pub tags: Option<Vec<String>>,
    pub time_of_day: Option<String>,
    pub atmosphere: Option<String>,
    pub season: Option<String>,
    pub number_of_people: Option<u32>,
    pub main_color: Option<String>,
    pub landmark: Option<String>,
    pub error: Option<String>
}

#[derive(Serialize, Deserialize, Debug)]
pub struct ImageInfoGallery {
    pub filename: String,
    pub s3_presigned_url: Option<String>,
    pub label: Option<String>,
    pub tags: Option<Vec<String>>,
    pub error: Option<String>
}
