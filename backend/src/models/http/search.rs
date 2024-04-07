use serde::{Deserialize, Serialize};

use super::images::ImageInfo;

#[derive(Deserialize, Serialize, Debug, Clone)]
pub struct ImageSearchQuery {
    // Image search query from the main page gallery
    pub text: Option<String>,
    pub tags: Option<Vec<String>>,
    pub time_of_day: Option<Vec<String>>,
    pub weather: Option<Vec<String>>,
    pub atmosphere: Option<Vec<String>>,
    pub season: Option<Vec<String>>,
    pub number_of_people: Option<Vec<u8>>,
    pub main_color: Option<Vec<String>>,
    pub orientation: Option<Vec<String>>,
    pub landmark: Option<String>, // No multi-choice (prob not used)
    pub grayscale: Option<bool>,  // No multi-choice
    pub error: Option<String>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SearchImageResponse {
    pub images: Vec<ImageInfo>,
    pub tags: Option<Vec<String>>,
    pub error: Option<String>,
}
