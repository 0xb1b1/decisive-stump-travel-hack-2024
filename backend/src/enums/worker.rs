use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
#[serde(tag = "task_type")]
pub enum TaskType {
    CompressImage {
        filename: String
    },
}
impl TaskType {
    pub fn file_name(&self) -> Option<&str> {
        match self {
            TaskType::CompressImage { filename } => {
                Some(filename.as_str())
            }
        }
    }
}
