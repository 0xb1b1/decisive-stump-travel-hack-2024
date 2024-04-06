use std::time::Duration;

use log;
use rocket::{http::Status, response::status, serde::json::Json};

use ds_travel_hack_2024::{
    models::http::search::{ImageSearchQuery, SearchImageResponse}, tasks::utils::requests::{search_query_is_not_empty, search_query_set_none_if_empty}, utils::redis::galleries::get_main_gallery
};

use crate::config::DsConfig;

pub fn routes() -> Vec<rocket::Route> {
    routes![search_images]
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

    search_query_set_none_if_empty(&mut filtered_data);

    let filters_set: bool = search_query_is_not_empty(&filtered_data);

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

    // if text in filtered data, include it in params
    let mut params: Vec<(&str, &str)>;
    if let Some(text) = filtered_data.text.as_ref() {
        params = vec![("text", text)];
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
    log::debug!("Serialized data to be sent: {}", serialized_data);

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
