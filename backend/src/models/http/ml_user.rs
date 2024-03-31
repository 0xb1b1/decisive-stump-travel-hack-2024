use serde::{Deserialize, Serialize};

#[derive(Deserialize, Debug)]
pub struct MLAnalyzeImage {
    pub filename: String
}

#[derive(Serialize, Debug)]
pub struct MLAnalyzeImageResponse {
    pub is_ml_processed: bool,
    pub tags: Option<Vec<String>>,
    pub filename: String,
    pub error: Option<String>
}
