use serde::Serialize;

#[derive(Serialize, Debug)]
pub struct ImageInfo {
    pub filename: String,
    pub s3_presigned_url: Option<String>,
    pub label: Option<String>,
    pub description: Option<String>,
    pub tags: Option<Vec<String>>,
    pub error: Option<String>
}
