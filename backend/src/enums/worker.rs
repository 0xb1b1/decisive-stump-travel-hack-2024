use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
#[serde(tag = "task_type")]
pub enum TaskType {
    CompressImage { filename: String, force: bool },
    DeleteImage { filename: String },
    GenS3PresignedUrls { filename: String, expiry_secs: u32 },
}
impl TaskType {
    pub fn as_str(&self) -> &str {
        match self {
            TaskType::CompressImage {
                filename: _,
                force: _,
            } => "CompressImage",
            TaskType::DeleteImage { filename: _ } => "DeleteImage",
            TaskType::GenS3PresignedUrls {
                filename: _,
                expiry_secs: _,
            } => "GenS3PresignedUrls",
        }
    }
}
