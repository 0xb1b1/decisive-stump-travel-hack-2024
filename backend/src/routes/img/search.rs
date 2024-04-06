use std::time::Duration;

use log;
use rocket::{http::Status, response::status, serde::json::Json};
use serde::{Deserialize, Serialize};

use ds_travel_hack_2024::{
    models::http::images::ImageInfo, utils::redis::galleries::get_main_gallery,
};

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

fn set_none_if_empty(query: &mut ImageSearchQuery) {
    if let Some(text_inner) = query.text.as_ref() {
        if text_inner.len() == 0 {
            query.text = None;
        }
    }
    if let Some(tags_inner) = query.tags.as_ref() {
        if tags_inner.len() == 0 {
            query.tags = None;
        }
    }
    if let Some(time_of_day_inner) = query.time_of_day.as_ref() {
        if time_of_day_inner.len() == 0 {
            query.time_of_day = None;
        }
    }
    if let Some(weather_inner) = query.weather.as_ref() {
        if weather_inner.len() == 0 {
            query.weather = None;
        }
    }
    if let Some(atmosphere_inner) = query.atmosphere.as_ref() {
        if atmosphere_inner.len() == 0 {
            query.atmosphere = None;
        }
    }
    if let Some(season_inner) = query.season.as_ref() {
        if season_inner.len() == 0 {
            query.season = None;
        }
    }
    if let Some(number_of_people_inner) = query.number_of_people.as_ref() {
        if number_of_people_inner.len() == 0 {
            query.number_of_people = None;
        }
    }
    if let Some(main_color_inner) = query.main_color.as_ref() {
        if main_color_inner.len() == 0 {
            query.main_color = None;
        }
    }
    if let Some(orientation_inner) = query.orientation.as_ref() {
        if orientation_inner.len() == 0 {
            query.orientation = None;
        }
    }
    if let Some(landmark_inner) = query.landmark.as_ref() {
        if landmark_inner.len() == 0 {
            query.landmark = None;
        }
    }
}

// Do not use HTTP GET since it's idempotent
// Use a custom QUERY method instead
#[post("/search?<images_limit>&<tags_limit>", data = "<data>")]
pub async fn search_images(
    data: Json<ImageSearchQuery>,
    images_limit: Option<u16>,
    tags_limit: Option<u16>,
    redis_pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
    config: &rocket::State<DsConfig>,
) -> status::Custom<Json<SearchImageResponse>> {
    log::debug!("Search request received: {:?}", data);

    // Ignore some params until ML implements them
    // TODO: Revisit the following after ML is complete
    let mut filtered_data = data.into_inner().clone();

    let client = reqwest::Client::builder()
        .timeout(Duration::from_secs(40))
        .build()
        .unwrap();

    set_none_if_empty(&mut filtered_data);

    let filters_set: bool = filtered_data.time_of_day.is_some()
        || filtered_data.weather.is_some()
        || filtered_data.atmosphere.is_some()
        || filtered_data.season.is_some()
        || filtered_data.number_of_people.is_some()
        || filtered_data.main_color.is_some()
        || filtered_data.orientation.is_some()
        || filtered_data.landmark.is_some()
        || filtered_data.grayscale.is_some();

    let text_set: bool =
        filtered_data.text.is_some() && filtered_data.text.as_ref().unwrap().len() > 0;

    log::debug!("Filters set: {}; Text set: {}", filters_set, text_set);

    let endpoint: &str;

    if text_set && !filters_set {
        log::debug!(
            "Searching images by text: {:?}",
            filtered_data.text.as_ref().unwrap()
        );
        endpoint = "search/text";
    } else if text_set && filters_set {
        log::debug!("Searching images by text and filters: {:?}", filtered_data);
        endpoint = "search/text";
    } else if !text_set && filters_set {
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
    let mut images: SearchImageResponse = match client.post(url).body(serialized_data).send().await
    {
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

    // Add thumbnails from Redis
    let full_gallery = match get_main_gallery(redis_pool).await {
        Ok(gallery) => gallery,
        Err(_) => {
            log::error!("Failed to get main gallery");
            return status::Custom(
                Status::InternalServerError,
                Json(SearchImageResponse {
                    images: vec![],
                    tags: None,
                    error: Some("Failed to get main gallery".to_string()),
                }),
            );
        }
    };

    for image in images.images.iter_mut() {
        image.s3_presigned_urls =
            match ds_travel_hack_2024::utils::redis::images::get_s3_presigned_urls_with_gallery(
                &image.filename,
                &full_gallery,
            )
            .await
            {
                Ok(urls) => urls,
                Err(_) => {
                    log::error!(
                        "Failed to get S3 presigned URLs for image: {}",
                        image.filename
                    );
                    None // TODO: Is this the correct behavior?
                }
            }
    }

    status::Custom(Status::Ok, Json(images))
}
