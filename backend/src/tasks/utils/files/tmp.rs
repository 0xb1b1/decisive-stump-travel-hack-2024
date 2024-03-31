use async_std::path::PathBuf;
use s3::{request::ResponseData, Bucket};

pub async fn download_s3_file(bucket: &Bucket, file_name: &str) -> Result<ResponseData, String> {
    log::info!("Downloading file: {}", file_name);
    let file = match bucket.get_object(file_name).await {
        Ok(file) => {
            log::info!("Downloaded file: {}", file_name);
            file
        },
        Err(err) => {
            log::error!("Failed to download file: {}", err);
            return Err(format!("Failed to download file: {}", err));
        }
    };

    Ok(file)
}

pub fn remove_tmp_file(file_path: &PathBuf) -> Result<(), ()> {
    // Check if file is in /tmp
    if !file_path.starts_with("/tmp/") {
        log::error!("File is not in /tmp: {:?}", file_path);
        return Err(());
    }

    log::debug!("Removing tmp file: {:?}", file_path);

    match std::fs::remove_file(file_path) {
        Ok(_) => {
            log::info!("Removed tmp file: {:?}", file_path);
            Ok(())
        },
        Err(err) => {
            log::error!("Failed to remove tmp file: {:?}", err);
            Err(())
        }
    }
}

pub fn get_file_name_no_ext(file_name: &str) -> Result<String, String> {
    // If file_name contains less than 2 parts, return error
    let parts: Vec<&str> = file_name.split('.').collect();
    // Collect all parts except the last one
    let mut new_parts: Vec<&str> = Vec::new();
    for i in 0..parts.len()-1 {
        new_parts.push(parts[i]);
    }

    log::debug!("File name parts: {:?}", new_parts);

    Ok(new_parts.join("."))
}
