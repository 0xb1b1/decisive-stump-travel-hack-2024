use std::env;

#[derive(Debug)]
pub struct DsConfig {
    pub svc_ml_fast: String,
    pub svc_ml_upload: String,
    pub upload_check_retries: u64,
    pub upload_check_interval_secs: u64,
    pub publish_check_retries: u64,
    pub publish_check_interval_secs: u64,
    pub s3_get_presigned_urls_timeout_secs: u32,
}

pub fn get_config() -> Result<DsConfig, std::env::VarError> {
    Ok(DsConfig {
        svc_ml_fast: env::var("DS_SVC_ML_FAST")?,
        svc_ml_upload: env::var("DS_SVC_ML_UPLOAD")?,
        upload_check_retries: env::var("DS_UPLOAD_CHECK_RETRIES")?.parse().unwrap_or(30),
        upload_check_interval_secs: env::var("DS_UPLOAD_CHECK_INTERVAL_SECS")?
            .parse()
            .unwrap_or(1),
        publish_check_retries: env::var("DS_PUBLISH_CHECK_RETRIES")?.parse().unwrap_or(14),
        publish_check_interval_secs: env::var("DS_PUBLISH_CHECK_INTERVAL_SECS")?
            .parse()
            .unwrap_or(1),
        s3_get_presigned_urls_timeout_secs: env::var("DS_S3_GET_PRESIGNED_URLS_TIMEOUT_SECS")?.parse().unwrap_or(30),
    })
}
