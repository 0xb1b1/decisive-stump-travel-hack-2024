use serde::{Serialize, Deserialize};

use super::images::ImageInfo;

#[derive(Serialize, Debug)]
pub struct GalleryResponse {
    pub images: Vec<ImageInfo>,
    pub error: Option<String>
}

// TODO: Move to another module to avoid confusion?
#[derive(Deserialize, Debug)]
pub struct RedisGalleryStore {
    pub images: Vec<ImageInfo>
}
