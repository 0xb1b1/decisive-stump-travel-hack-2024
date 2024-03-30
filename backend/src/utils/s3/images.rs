use log;
use s3::{
    Bucket,
    request::ResponseData
};

// Read file and return its object if exists
pub async fn get_img(file_path: &str, bucket: &Bucket) -> Option<ResponseData> {
    // file_path is the path to file in s3
    // bucket is the s3 bucket
    match bucket.get_object(file_path).await {
        Ok(data) => {
            log::info!("File found: {}", &file_path);
            Some(data)
        },
        Err(e) => {
            log::error!("Failed to get file: {}", e);
            None
        }
    }
}
