use log;
use s3::{request::ResponseData, Bucket};

// Read file and return its object if exists
pub async fn get_img(file_path: &str, bucket: &Bucket) -> Option<ResponseData> {
    // file_path is the path to file in s3
    // bucket is the s3 bucket
    match bucket.get_object(file_path).await {
        Ok(data) => {
            log::info!("File found: {}", &file_path);
            Some(data)
        }
        Err(e) => {
            log::error!("Failed to get file: {}", e);
            None
        }
    }
}

// pub async fn get_image_list(bucket: &Bucket) -> Option<Vec<String>> {  // TODO: Fix this returns only `images`
//     // List everything in the images bucket
//     match bucket.list("/images".into(), Some("/".into())).await {
//         Ok(list) => {
//             let mut files = Vec::new();
//             for obj in list.into_iter() {
//                 files.push(obj.name);
//             }
//             Some(files)
//         },
//         Err(e) => {
//             log::error!("Failed to get file list: {}", e);
//             None
//         }
//     }
// }

pub async fn get_presigned_url(
    file_path: &str,
    bucket: &Bucket,
    expiry_secs: u32,
) -> Option<String> {
    // WARNING: This function will result in a presigned URL even if the file doesn't exist
    match bucket.presign_get(file_path, expiry_secs, None) {
        Ok(url) => {
            log::info!(
                "Presigned URL generated, valid for {} seconds: {}",
                expiry_secs,
                url
            );
            Some(url)
        }
        Err(e) => {
            log::error!("Failed to generate presigned URL: {}", e);
            None
        }
    }
}
