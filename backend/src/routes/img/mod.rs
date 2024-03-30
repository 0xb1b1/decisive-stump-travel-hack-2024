mod file_ops;
mod ml_ops;

pub fn routes() -> Vec<rocket::Route> {
    let mut rocket_routes = file_ops::routes();
    rocket_routes.append(&mut ml_ops::routes());

    rocket_routes
}
