mod files;
mod search;
mod ml;
mod main_page;

pub fn routes() -> Vec<rocket::Route> {
    let mut rocket_routes = files::routes();
    rocket_routes.append(&mut ml::routes());
    rocket_routes.append(&mut search::routes());
    rocket_routes.append(&mut main_page::routes());

    rocket_routes
}
