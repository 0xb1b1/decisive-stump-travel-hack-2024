#[macro_use]
extern crate rocket;

use env_logger;
use rocket::fairing::{Fairing, Info, Kind};
use rocket::http::Header;
use rocket::serde::json::Json;
use rocket::{Request, Response};

mod config;
mod routes;

use ds_travel_hack_2024::connections;

pub struct CORS;

#[rocket::async_trait]
impl Fairing for CORS {
    fn info(&self) -> Info {
        Info {
            name: "Add CORS headers to responses",
            kind: Kind::Response,
        }
    }

    async fn on_response<'r>(&self, _request: &'r Request<'_>, response: &mut Response<'r>) {
        response.set_header(Header::new("Access-Control-Allow-Origin", "*"));
        response.set_header(Header::new(
            "Access-Control-Allow-Methods",
            "POST, GET, PATCH, OPTIONS",
        ));
        response.set_header(Header::new("Access-Control-Allow-Headers", "*"));
        response.set_header(Header::new("Access-Control-Allow-Credentials", "true"));
    }
}

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

    log::info!("Creating configuration...");
    let config = config::get_config().unwrap();
    log::info!("Created configuration: {:?}", config);
    // let limits = Limits::default()
    //     .limit("data-form", 64.mebibytes())
    //     .limit("file", 64.mebibytes());
    rocket::build()
        .attach(CORS)
        .manage(redis_pool)
        .manage(rsmq_pool)
        .manage(bucket)
        .manage(click)
        .manage(config)
        .mount("/", routes![get_root])
        .mount("/img", routes::img::routes())
        .mount("/test", routes::test::routes())
}
