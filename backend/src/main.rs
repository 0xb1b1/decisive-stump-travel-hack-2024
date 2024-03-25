#[macro_use]
extern crate rocket;

use env_logger;
use rocket::serde::json::Json;

mod connections;
mod routes;
mod utils;


// fn main() {
//     if env::var("RUST_LOG").is_err() {
//         env::set_var("RUST_LOG", "debug");
//         env_logger::init();
//         log::warn!("RUST_LOG env var unset.")
//     } else {
//         env_logger::init();
//     }

//     let click: clickhouse::Client = match connections::click::get_client() {
//         Ok(conn) => conn,
//         Err(e) => {
//             log::error!("{}", format!("Failed to create connection to ClickHouse: {}", e));
//             panic!("Unexpected error during ClickHouse connection.")
//         }
//     };
// }

#[get("/")]
async fn get_root() -> Json<String> {
    return Json(String::from("Ok."))
}

#[launch]
async fn rocket() -> _ {
    env_logger::init();

    // let limits = Limits::default()
    //     .limit("data-form", 64.mebibytes())
    //     .limit("file", 64.mebibytes());
    rocket::build()
        .mount(
            "/",
            routes![get_root]
        )
        .mount(
            "/img",
            routes::img::routes()
        )

}
