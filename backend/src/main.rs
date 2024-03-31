#[macro_use]
extern crate rocket;

use env_logger;
use rocket::serde::json::Json;
use s3::Bucket;

mod connections;
mod models;
mod routes;
mod utils;
mod locks;
mod enums;

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

    log::info!("Creating Redis pool...");
    let redis_pool = connections::redis::get_pool().await.unwrap();
    log::info!("Created Redis pool.");

    log::info!("Creating RSMQ pool...");
    // RSMQ uses a built-in connection pool
    let rsmq_pool = connections::rsmq::get_pool().await.unwrap();
    log::info!("Created RSMQ pool.");

    log::info!("Connecting to Minio...");
    let bucket = connections::s3::get_bucket(None).await.unwrap();
    log::info!("Connected to Minio.");

    log::info!("Connecting to ClickHouse...");
    let click = connections::click::get_client().await.unwrap();
    log::info!("Connected to ClickHouse.");

    // let limits = Limits::default()
    //     .limit("data-form", 64.mebibytes())
    //     .limit("file", 64.mebibytes());
    rocket::build()
        .manage(redis_pool)
        .manage(rsmq_pool)
        .manage(bucket)
        .manage(click)
        .mount(
            "/",
            routes![get_root]
        )
        .mount(
            "/img",
            routes::img::routes()
        )
        .mount(
            "/test",
            routes::test::routes()
        )
}
