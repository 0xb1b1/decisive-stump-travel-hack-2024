use serde::{Serialize, Deserialize};

use super::images::{ImageInfo, ImageInfoGallery};

#[derive(Serialize, Debug)]
pub struct GalleryResponse {
    pub images: Vec<ImageInfoGallery>,
    pub error: Option<String>
}

// TODO: Move to another module to avoid confusion?
#[derive(Serialize, Deserialize, Debug)]
pub struct RedisGalleryStore {
    pub images: Vec<ImageInfoGallery>
}
