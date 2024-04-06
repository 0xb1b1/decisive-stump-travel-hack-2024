use crate::models::http::search::ImageSearchQuery;

pub fn search_query_set_none_if_empty(query: &mut ImageSearchQuery) {
    if let Some(text_inner) = query.text.as_ref() {
        if text_inner.len() == 0 {
            query.text = None;
        }
    }
    if let Some(tags_inner) = query.tags.as_ref() {
        if tags_inner.len() == 0 {
            query.tags = None;
        }
    }
    if let Some(time_of_day_inner) = query.time_of_day.as_ref() {
        if time_of_day_inner.len() == 0 {
            query.time_of_day = None;
        }
    }
    if let Some(weather_inner) = query.weather.as_ref() {
        if weather_inner.len() == 0 {
            query.weather = None;
        }
    }
    if let Some(atmosphere_inner) = query.atmosphere.as_ref() {
        if atmosphere_inner.len() == 0 {
            query.atmosphere = None;
        }
    }
    if let Some(season_inner) = query.season.as_ref() {
        if season_inner.len() == 0 {
            query.season = None;
        }
    }
    if let Some(number_of_people_inner) = query.number_of_people.as_ref() {
        if number_of_people_inner.len() == 0 {
            query.number_of_people = None;
        }
    }
    if let Some(main_color_inner) = query.main_color.as_ref() {
        if main_color_inner.len() == 0 {
            query.main_color = None;
        }
    }
    if let Some(orientation_inner) = query.orientation.as_ref() {
        if orientation_inner.len() == 0 {
            query.orientation = None;
        }
    }
    if let Some(landmark_inner) = query.landmark.as_ref() {
        if landmark_inner.len() == 0 {
            query.landmark = None;
        }
    }
}

pub fn search_query_is_not_empty(query: &ImageSearchQuery) -> bool {
    query.text.is_some()
        || query.tags.is_some()
        || query.time_of_day.is_some()
        || query.weather.is_some()
        || query.atmosphere.is_some()
        || query.season.is_some()
        || query.number_of_people.is_some()
        || query.main_color.is_some()
        || query.orientation.is_some()
        || query.landmark.is_some()
        || query.grayscale.is_some()
}
