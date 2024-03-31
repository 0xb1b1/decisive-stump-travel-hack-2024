use serde::Serialize;

#[derive(Serialize, Debug)]
pub struct ImageInfo {
    pub filename: String,
    pub tags: Option<Vec<String>>,
    pub error: Option<String>
}
