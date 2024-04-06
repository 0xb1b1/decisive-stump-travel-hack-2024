use serde::{Deserialize, Serialize};

use crate::utils::redis::images::get_s3_presigned_urls;

use super::images::ImageInfoGallery;

#[derive(Serialize, Debug)]
pub struct GalleryResponse {
    pub images: Vec<ImageInfoGallery>,
    pub token: String,
    pub error: Option<String>,
}

// TODO: Move to another module to avoid confusion?
#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct RedisGalleryStore {
    pub images: Vec<ImageInfoGallery>,
    pub error: Option<String>,
}
impl RedisGalleryStore {
    pub fn new() -> Self {
        RedisGalleryStore {
            images: vec![],
            error: None,
        }
    }

    // pub fn add_s3_presigned_urls(&mut self, ) {  # TODO!
    //     for img in self.images.iter_mut() {
    //         img.s3_presigned_urls = match get_s3_presigned_urls(filename, redis_pool)
    //     }
    // }
}

