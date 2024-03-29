use log;
use s3::{
    Bucket,
    request::ResponseData
};

// Read file and return its object if exists
pub async fn get_img(file_path: &str, bucket: &Bucket) -> Option<ResponseData> {
    // file_path is the path to file in s3
    // bucket is the s3 bucket
    let response = bucket.get_object(file_path).await;
    match response {
        Ok(data) => {
            log::info!("File found: {:?}", data);
            Some(data)
        },
        Err(e) => {
            log::error!("Failed to get file: {}", e);
            None
        }
    }
}