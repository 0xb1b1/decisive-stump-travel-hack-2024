use log;
use rocket::{http::Status, response::status, serde::json::Json};
use serde::{Deserialize, Serialize};

use ds_travel_hack_2024::models::http::images::ImageInfo;

pub fn routes() -> Vec<rocket::Route> {
    routes![search_image_by_text]
}

#[derive(Deserialize, Debug)]
pub struct ImageSearchQuery {
    // Image search query from the main page gallery
    pub text: Option<String>,
    pub label: Option<String>,
    pub time_of_day: Option<String>,
    pub weather: Option<String>,
    pub atmosphere: Option<String>,
    pub season: Option<String>,
    pub number_of_people: Option<u8>,
    pub colors: Option<String>,
    pub landmark: Option<String>, // No multi-choice  (prob not used)
    pub grayscale: Option<bool>,  // No multi-choice
    pub error: Option<String>,
}

#[derive(Serialize, Debug)]
pub struct SearchImageResponse {
    pub images: Vec<ImageInfo>,
    pub error: Option<String>,
}

// Do not use HTTP GET since it's idempotent
// Use a custom QUERY method instead
#[post("/search/text", data = "<data>")]
pub async fn search_image_by_text(
    data: Json<ImageSearchQuery>,
) -> status::Custom<Json<SearchImageResponse>> {
    log::debug!("Search request received: {:?}", data);

    // TODO: Determine which ML endpoint to use for the search

    // Mock response
    status::Custom(
        Status::Ok,
        Json(SearchImageResponse {
            images: vec![],
            error: None,
        }),
    )
}
