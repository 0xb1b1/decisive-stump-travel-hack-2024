use serde::{Deserialize, Serialize};

use crate::models::http::images::ImageInfo;

#[derive(Serialize, Deserialize, Debug)]
#[serde(tag = "task_type")]
pub enum MlTaskType {
    AddImage {
        filename: String,
        label: Option<String>,
        tags: Option<Vec<String>>,
        time_of_day: Option<String>,
        weather: Option<String>,
        atmosphere: Option<String>,
        season: Option<String>,
        number_of_people: Option<u8>,
        main_color: Option<String>,
        orientation: Option<String>,
        landmark: Option<String>,
        grayscale: Option<bool>,
        error: Option<String>,
    }
}
impl MlTaskType {
    pub fn new(filename: &str) -> Self {
        MlTaskType::AddImage {
            filename: String::from(filename),
            label: None,
            tags: None,
            time_of_day: None,
            weather: None,
            atmosphere: None,
            season: None,
            number_of_people: None,
            main_color: None,
            orientation: None,
            landmark: None,
            grayscale: None,
            error: None,
        }
    }

    pub fn as_str(&self) -> &str {
        match self {
            MlTaskType::AddImage {
                filename: _, label: _,
                tags: _, time_of_day: _,
                weather: _, atmosphere: _,
                season: _, number_of_people: _,
                main_color: _, orientation: _,
                landmark: _, grayscale: _,
                error: _,
            } => "AddImage",
        }
    }

    pub fn from_image_info(&self, image_info: ImageInfo) -> Self {
        match self {
            MlTaskType::AddImage {
                filename: _, label: _,
                tags: _, time_of_day: _,
                weather: _, atmosphere: _,
                season: _, number_of_people: _,
                main_color: _, orientation: _,
                landmark: _, grayscale: _,
                error: _,
            } => MlTaskType::AddImage {
                filename: image_info.filename.clone(),
                label: image_info.label.clone(),
                tags: image_info.tags.clone(),
                time_of_day: image_info.time_of_day.clone(),
                weather: image_info.weather.clone(),
                atmosphere: image_info.atmosphere.clone(),
                season: image_info.season.clone(),
                number_of_people: image_info.number_of_people,
                main_color: image_info.main_color.clone(),
                orientation: image_info.orientation.clone(),
                landmark: image_info.landmark.clone(),
                grayscale: image_info.grayscale,
                error: image_info.error.clone(),
            },
        }
    }
}
