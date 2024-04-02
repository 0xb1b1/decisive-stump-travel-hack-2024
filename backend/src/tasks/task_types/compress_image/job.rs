use s3::request::ResponseData;
use s3::Bucket;

pub struct CompressionParams {
    pub quality: f32,
    pub size_ratio: f32
}


pub async fn compress(
    file: &ResponseData,
    filename: &str,
    output_bucket: &Bucket,
    params: CompressionParams

) -> Result<(), String> {
    // if original_file_length < 2_000_000 {
    //     log::info!("File is already compressed, copying to comp bucket.");
    //     match bucket.put_object(&filename, file.as_slice()).await {
    //         Ok(_) => {
    //             log::info!("Copied image to comp bucket.");
    //             compressed_result = Ok(());
    //         },
    //         Err(err) => {
    //             log::error!("Failed to copy image to comp bucket: {}", err);
    //             compressed_result = Err(());
    //         }
    //     }
    // log::info!("File is not small enough for comp bucket, compressing it.");

    match crate::tasks::compress::compress_image(
        &file,
        &filename,
        &output_bucket,
        params.quality,
        params.size_ratio
    ).await {
        Ok(image_info) => {
            log::info!("Compressed image (comp bucket): {:?}", image_info);
            return Ok(());
        },
        Err(err) => {
            log::error!("Failed to compress image (comp bucket), failing: {}", err);
            return Err("Failed to compress image (comp bucket), failing.".into());
        }
    };
}