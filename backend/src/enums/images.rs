use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
#[serde(tag = "time_of_day")]
pub enum TimeOfDay {
    Morning,
    Afternoon,
    Evening,
    Night,
}
impl TimeOfDay {
    pub fn from_str(s: &str) -> Option<Self> {
        match s {
            "morning" => Some(Self::Morning),
            "afternoon" => Some(Self::Afternoon),
            "evening" => Some(Self::Evening),
            "night" => Some(Self::Night),
            _ => None,
        }
    }
    pub fn to_str(&self) -> &str {
        match self {
            Self::Morning => "morning",
            Self::Afternoon => "afternoon",
            Self::Evening => "evening",
            Self::Night => "night",
        }
    }
}
