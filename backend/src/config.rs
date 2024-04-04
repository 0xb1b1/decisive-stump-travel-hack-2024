use std::env;

#[derive(Debug)]
pub struct DsConfig {
    pub svc_ml_fast: String,
    pub svc_ml_upload: String,
}

pub fn get_config() -> Result<DsConfig, std::env::VarError> {
    Ok(DsConfig {
        svc_ml_fast: env::var("DS_SVC_ML_FAST")?,
        svc_ml_upload: env::var("DS_SVC_ML_UPLOAD")?,
    })
}
