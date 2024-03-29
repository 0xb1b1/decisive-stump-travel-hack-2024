use awscreds::Credentials;
use awsregion::Region;
use s3::{
    Bucket,
    BucketConfiguration
};
use std::env;

// Get minio images bucket
pub async fn get_bucket() -> Result<Bucket, String> {
    // Get credentials
    let access_key = match env::var("DS_MINIO_IMAGES_ACCESS_KEY") {
        Ok(var) => var,
        Err(_) => {
            return Err("Minio Access Key not defined.".into());
        }
    };

    let secret_key = match env::var("DS_MINIO_IMAGES_SECRET_KEY") {
        Ok(var) => var,
        Err(_) => {
            return Err("Minio Secret Key not defined.".into());
        }
    };

    let credentials = match Credentials::new(
        Some(&access_key),
        Some(&secret_key),
        None,
        None,
        None
    ) {
        Ok(creds) => creds,
        Err(err) => {
            return Err(format!("Failed to generate S3 credentials: {}", err));

        }
    };

    let bucket_name = match env::var("DS_MINIO_BUCKET_NAME") {
        Ok(var) => var,
        Err(_) => {
            log::warn!("Minio Bucket Name not defined, using fallback `images` bucket.");
            "images".into()
        }
    };

    let region = Region::Custom {
        region: "eu-central-1".to_owned(),
        endpoint: match env::var("DS_MINIO_ENDPOINT") {
            Ok(var) => {
                log::debug!("Using custom Minio endpoint: {}", var);
                var
            },
            Err(_) => {
                return Err("Minio Endpoint not defined.".into());
            }
        }
    };

    let bucket = match Bucket::create_with_path_style(
        &bucket_name,
        region.clone(),
        credentials.clone(),
        BucketConfiguration::default()
    ).await {
        Ok(b) => b.bucket.with_path_style(),
        Err(err) => {
            log::debug!("Failed to create bucket, initializing instead: {}", err);
            match Bucket::new(
                &bucket_name,
                region,
                credentials
            ) {
                Ok(b) => b.with_path_style(),
                Err(err) => {
                    return Err(format!("Failed to initialize bucket: {}", err));
                }
            }
        }
    };


    Ok(bucket)
}
