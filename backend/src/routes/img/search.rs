use log;
use rocket::{http::Status, response::status, serde::json::Json};
use serde::{Deserialize, Serialize};

use crate::models::http::images::ImageInfo;

pub fn routes() -> Vec<rocket::Route> {
    routes![search_image_by_text]
}

#[derive(Deserialize, Debug)]
pub struct SearchImageByText {
    pub text: String,
}

#[derive(Serialize, Debug)]
pub struct SearchImageResponse {
    pub images_count: u32,
    pub images: Vec<ImageInfo>,
    pub error: Option<String>,
}

// Do not use HTTP GET since it's idempotent
// Use a custom QUERY method instead
#[post("/search/text", data = "<text>")]
pub async fn search_image_by_text(
    text: Json<SearchImageByText>,
    click: &rocket::State<klickhouse::Client>,
) -> status::Custom<Json<SearchImageResponse>> {
    log::debug!("Search request received: {:?}", text);

    // TODO
    // let results = click.execute(
    //     "SELECT * "
    //     (text.text,)
    // ).await.unwrap();

    // Mock response
    status::Custom(
        Status::Ok,
        Json(SearchImageResponse {
            images_count: 0,
            images: vec![],
            error: None,
        }),
    )
}
