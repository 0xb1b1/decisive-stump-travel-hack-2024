use log;
use rocket::{http::Status, response::status, serde::json::Json};
use serde::{Deserialize, Serialize};

use ds_travel_hack_2024::models::http::images::ImageInfo;

pub fn routes() -> Vec<rocket::Route> {
    routes![search_images]
}

#[derive(Deserialize, Debug)]
pub struct ImageSearchQuery {
    // Image search query from the main page gallery
    pub text: Option<Vec<String>>,
    pub time_of_day: Option<Vec<String>>,
    pub weather: Option<Vec<String>>,
    pub atmosphere: Option<Vec<String>>,
    pub season: Option<Vec<String>>,
    pub number_of_people: Option<u8>,
    pub colors: Option<Vec<String>>,
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
#[post("/search", data = "<data>")]
pub async fn search_images(
    data: Json<ImageSearchQuery>,
) -> status::Custom<Json<SearchImageResponse>> {
    log::debug!("Search request received: {:?}", data);

    let filters_set: bool = data.time_of_day.is_some()
        || data.weather.is_some()
        || data.atmosphere.is_some()
        || data.season.is_some()
        || data.number_of_people.is_some()
        || data.colors.is_some()
        || data.landmark.is_some()
        || data.grayscale.is_some();

    if data.text.is_some() && !filters_set {
        // Search by text only
        log::debug!(
            "Searching images by text: {:?}",
            data.text.as_ref().unwrap()
        );
        log::warn!("TODO: Implement search by text only");
    } else if data.text.is_some() && filters_set {
        // Search by text and filters
        log::debug!("Searching images by text and filters: {:?}", data);
        log::warn!("TODO: Implement search by text and filters");
    } else if !data.text.is_some() && filters_set {
        // Search by filters
        log::debug!("Searching images by filters: {:?}", data);
        log::warn!("TODO: Implement search by filters only");
    } else {
        // No search criteria
        log::debug!("No search criteria provided, returning empty response");
        return status::Custom(
            Status::BadRequest,
            Json(SearchImageResponse {
                images: vec![],
                error: Some("No search criteria provided".to_string()),
            }),
        );
    }

    // Mock response
    status::Custom(
        Status::Ok,
        Json(SearchImageResponse {
            images: vec![],
            error: None,
        }),
    )
}
