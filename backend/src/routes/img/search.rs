use std::time::Duration;

use log;
use rocket::{http::Status, response::status, serde::json::Json};
use serde::{Deserialize, Serialize};

use ds_travel_hack_2024::models::http::images::ImageInfo;

use crate::config::DsConfig;

pub fn routes() -> Vec<rocket::Route> {
    routes![search_images]
}

#[derive(Deserialize, Serialize, Debug, Clone)]
pub struct ImageSearchQuery {
    // Image search query from the main page gallery
    pub text: Option<String>,
    pub tags: Option<Vec<String>>,
    pub time_of_day: Option<Vec<String>>,
    pub weather: Option<Vec<String>>,
    pub atmosphere: Option<Vec<String>>,
    pub season: Option<Vec<String>>,
    pub number_of_people: Option<u8>,
    pub main_color: Option<Vec<String>>,
    pub orientation: Option<Vec<String>>,
    pub landmark: Option<String>, // No multi-choice  (prob not used)
    pub grayscale: Option<bool>,  // No multi-choice
    pub error: Option<String>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct SearchImageResponse {
    pub images: Vec<ImageInfo>,
    pub tags: Option<Vec<String>>,
    pub error: Option<String>,
}

// Do not use HTTP GET since it's idempotent
// Use a custom QUERY method instead
#[post("/search?<images_limit>&<tags_limit>", data = "<data>")]
pub async fn search_images(
    data: Json<ImageSearchQuery>,
    images_limit: Option<u16>,
    tags_limit: Option<u16>,
    config: &rocket::State<DsConfig>,
) -> status::Custom<Json<SearchImageResponse>> {
    log::debug!("Search request received: {:?}", data);

    // Ignore some params until ML implements them
    // TODO: Revisit the following after ML is complete
    let mut filtered_data = data.into_inner().clone();
    filtered_data.orientation = None;

    let client = reqwest::Client::builder()
        .timeout(Duration::from_secs(40))
        .build()
        .unwrap();

    let filters_set: bool = filtered_data.time_of_day.is_some()
        || filtered_data.weather.is_some()
        || filtered_data.atmosphere.is_some()
        || filtered_data.season.is_some()
        || filtered_data.number_of_people.is_some()
        || filtered_data.main_color.is_some()
        || filtered_data.landmark.is_some()
        || filtered_data.grayscale.is_some();

    let endpoint: &str;

    if filtered_data.text.is_some() && !filters_set {
        // Search by text only
        log::debug!(
            "Searching images by text: {:?}",
            filtered_data.text.as_ref().unwrap()
        );
        endpoint = "search/text";
    } else if filtered_data.text.is_some() && filters_set {
        // Search by text and filters
        log::debug!("Searching images by text and filters: {:?}", filtered_data);
        endpoint = "search/text";
    } else if !filtered_data.text.is_some() && filters_set {
        // Search by filters
        log::debug!("Searching images by filters: {:?}", filtered_data);
        endpoint = "search/filters";
    } else {
        // No search criteria
        log::debug!("No search criteria provided, returning empty response");
        return status::Custom(
            Status::BadRequest,
            Json(SearchImageResponse {
                images: vec![],
                tags: None,
                error: Some("No search criteria provided".to_string()),
            }),
        );
    }

    let mut params: Vec<(&str, &str)>;
    if let Some(text_inner) = filtered_data.text.as_ref() {
        params = vec![("text", &text_inner)];
    } else {
        params = vec![];
    }

    let images_limit_param = images_limit.unwrap_or(10).to_string();
    let tags_limit_param = tags_limit.unwrap_or(10).to_string();

    params.push(("neighbors_limit", &images_limit_param));
    params.push(("limit", &images_limit_param)); // Same as images_limit
    params.push(("tags_limit", &tags_limit_param));

    let url = match reqwest::Url::parse_with_params(
        &format!("{}/{}", config.svc_ml_upload, endpoint),
        params,
    ) {
        Ok(url) => url,
        Err(err) => {
            log::error!("Failed to parse URL: {}", err);
            return status::Custom(
                Status::InternalServerError,
                Json(SearchImageResponse {
                    images: vec![],
                    tags: None,
                    error: Some("Failed to parse URL".to_string()),
                }),
            );
        }
    };

    let serialized_data = serde_json::to_string(&filtered_data).unwrap();

    log::debug!("Sending request to: {}", url);
    let images: SearchImageResponse = match client.post(url).body(serialized_data).send().await {
        Ok(response) => match response.text().await {
            Ok(images_str) => match serde_json::from_str(&images_str) {
                Ok(images) => images,
                Err(err) => {
                    log::error!("Failed to parse response: {}", err);
                    log::error!("Raw response: {}", images_str);
                    SearchImageResponse {
                        images: vec![],
                        tags: None,
                        error: Some("Failed to parse response".to_string()),
                    }
                }
            },
            Err(err) => {
                log::error!("Failed to parse response: {}", err);
                SearchImageResponse {
                    images: vec![],
                    tags: None,
                    error: Some("Failed to parse response".to_string()),
                }
            }
        },
        Err(err) => {
            log::error!("Failed to send request: {}", err);
            SearchImageResponse {
                images: vec![],
                tags: None,
                error: Some("Failed to send request".to_string()),
            }
        }
    };

    status::Custom(Status::Ok, Json(images))
}
