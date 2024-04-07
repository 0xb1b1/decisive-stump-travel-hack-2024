mod search_by_photo;

pub fn routes() -> Vec<rocket::Route> {
    let rocket_routes = search_by_photo::routes();

    rocket_routes
}
