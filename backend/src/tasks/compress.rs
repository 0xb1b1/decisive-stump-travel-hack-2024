use async_std::path::PathBuf;
use image_compressor::{compressor::Compressor, Factor};
use s3::request::ResponseData;
use s3::Bucket;

use crate::models::http::images::ImageInfo;
use crate::tasks::utils::files::tmp::{get_file_name_no_ext, remove_tmp_file};

pub async fn compress_image(
    file: &ResponseData,
    file_name: &str,
    output_bucket: &Bucket,
    quality: f32,
    size_ratio: f32,
) -> Result<ImageInfo, String> {
    log::info!("Processing CompressImage task for file: {}", file_name);

    let tmp_path_src = PathBuf::from(format!("/tmp/{}", file_name));
    let tmp_path_dir_dest = PathBuf::from("/tmp/ds_compressed");
    let file_name_no_ext = match get_file_name_no_ext(&file_name) {
        Ok(name) => name,
        Err(err) => {
            log::error!(
                "Failed to get file name without extension, failing: {}",
                err
            );
            remove_tmp_file(&tmp_path_src).unwrap();
            return Err(format!(
                "Failed to get file name without extension: {}",
                err
            ));
        }
    };
    let tmp_path_dest = &tmp_path_dir_dest.join(format!("{}.{}", &file_name_no_ext, "jpg"));

    // Create tmp dir
    match std::fs::create_dir_all(&tmp_path_dir_dest) {
        Ok(_) => {
            log::debug!("Created tmp dir: {:?}", &tmp_path_dir_dest);
        }
        Err(err) => {
            log::error!("Failed to create tmp dir: {}", err);
            remove_tmp_file(&tmp_path_src).unwrap();
            return Err(format!("Failed to create tmp dir: {}", err));
        }
    }

    // Save to /tmp
    match std::fs::write(&tmp_path_src, file.as_slice()) {
        Ok(_) => {
            log::debug!("Saved image to tmp: {:?}", &tmp_path_src);
        }
        Err(err) => {
            log::error!("Failed to save image to tmp: {}", err);
            match remove_tmp_file(&tmp_path_src) {
                Ok(_) => (),
                Err(_) => {
                    log::error!(
                        "Failed to remove previously compressed file: {:?}",
                        &tmp_path_src
                    );
                }
            }
            remove_tmp_file(&tmp_path_src).unwrap();
            return Err(format!("Failed to save image to tmp: {}", err));
        }
    }

    // Compress image
    let mut comp = Compressor::new(&tmp_path_src, &tmp_path_dir_dest);

    log::debug!(
        "Setting compression quality, size ratio to {}%, {}...",
        &quality,
        &size_ratio
    );
    comp.set_factor(Factor::new(quality, size_ratio));
    log::debug!("Compressing image...");
    match comp.compress_to_jpg() {
        Ok(_) => (),
        Err(err) => {
            log::error!("Failed to compress image: {}", err);
            match remove_tmp_file(&tmp_path_dest) {
                Ok(_) => {
                    log::info!("Removed tmp file, trying again: {:?}", &tmp_path_src);
                    match comp.compress_to_jpg() {
                        Ok(_) => {
                            log::info!("Compressed image: {:?}", &tmp_path_src);
                        }
                        Err(err) => {
                            log::error!("Failed to compress image, giving up: {}", err);
                            remove_tmp_file(&tmp_path_src).unwrap();
                            return Err(format!("Failed to compress image: {}", err));
                        }
                    }
                }
                Err(_) => {
                    log::error!("Failed to remove tmp file: {:?}", &tmp_path_dest);
                    remove_tmp_file(&tmp_path_src).unwrap();
                    return Err(format!("Failed to compress image: {}", err));
                }
            }
        }
    }

    log::debug!("Uploading compressed image to Compressed Images bucket...");
    let compressed_image = match std::fs::read(&tmp_path_dest) {
        Ok(image) => image,
        Err(err) => {
            log::error!(
                "Failed to read compressed image, removing destination directory: {}",
                err
            );
            match remove_tmp_file(&tmp_path_dir_dest) {
                Ok(_) => (),
                Err(_) => {
                    log::error!("Failed to remove tmp file: {:?}", &tmp_path_src);
                }
            }
            remove_tmp_file(&tmp_path_src).unwrap();
            remove_tmp_file(&tmp_path_dest).unwrap();
            return Err(format!("Failed to read compressed image: {}", err));
        }
    };

    log::info!("Uploading compressed image: {}", file_name);
    match output_bucket
        .put_object(file_name, compressed_image.as_slice())
        .await
    {
        Ok(_) => {
            log::info!("Uploaded compressed image: {}", file_name);
            remove_tmp_file(&tmp_path_src).unwrap();
            remove_tmp_file(&tmp_path_dest).unwrap();
            return Ok(ImageInfo {
                filename: format!("{}.{}", &file_name_no_ext, "jpg"),
                s3_presigned_url: None, // TODO: Generate?
                label: None,
                tags: None,
                time_of_day: None,
                weather: None,
                atmosphere: None,
                season: None,
                number_of_people: None,
                color: None,
                landmark: None,
                grayscale: None,
                error: None,
            });
        }
        Err(err) => {
            log::error!("Failed to upload compressed image: {}", err);
            match remove_tmp_file(&tmp_path_src) {
                Ok(_) => (),
                Err(_) => {
                    log::error!("Failed to remove tmp file: {:?}", &tmp_path_src);
                }
            }
            remove_tmp_file(&tmp_path_src).unwrap();
            remove_tmp_file(&tmp_path_dest).unwrap();
            return Err(format!("Failed to upload compressed image: {}", err));
        }
    }
}
