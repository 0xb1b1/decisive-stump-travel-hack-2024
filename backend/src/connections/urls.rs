use std::env;

#[derive(Debug)]
pub struct DsUrls {
    pub ml_neighbors_fast: String,
    pub ml_neighbors_upload: String,
}

pub fn get_urls() -> DsUrls {
    DsUrls {
        ml_neighbors_fast: env::var("DS_SVC_ML_NEIGHBORS_FAST")
            .expect("DS_SVC_ML_NEIGHBORS_FAST not defined."),
        ml_neighbors_upload: env::var("DS_SVC_ML_NEIGHBORS_UPLOAD")
            .expect("DS_SVC_ML_NEIGHBORS_UPLOAD not defined."),
    }
}
