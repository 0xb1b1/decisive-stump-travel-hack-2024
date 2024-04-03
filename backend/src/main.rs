#[macro_use]
extern crate rocket;

mod routes;

use env_logger;
use rocket::serde::json::Json;

use ds_travel_hack_2024::connections;

#[get("/")]
async fn get_root() -> Json<String> {
    return Json(String::from("Ok."));
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
    let bucket = ds_travel_hack_2024::connections::s3::get_bucket(None)
        .await
        .unwrap();
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
        .mount("/", routes![get_root])
        .mount("/img", routes::img::routes())
        .mount("/test", routes::test::routes())
}
