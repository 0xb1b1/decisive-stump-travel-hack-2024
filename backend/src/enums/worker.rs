use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
#[serde(tag = "task_type")]
pub enum TaskType {
    CompressImage { filename: String },
    DeleteImage { filename: String },
}
impl TaskType {
    pub fn as_str(&self) -> &str {
        match self {
            TaskType::CompressImage { filename: _ } => "CompressImage",
            TaskType::DeleteImage { filename: _ } => "DeleteImage",
        }
    }
}
