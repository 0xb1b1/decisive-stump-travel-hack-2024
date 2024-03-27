use rocket::{
    serde::json::Json,
    http::Status,
    // response::Responder,
    response::status
    // State, data::{Limits, ToByteUnit}
};
use log;
// use std::{path, time::Duration};
// use std::fs;
use bb8;
use bb8_redis;
use redis;


pub fn routes() -> Vec<rocket::Route> {
    routes![
        test_redis
    ]
}

#[derive(serde::Deserialize, Debug)]
struct TestRedis {
    key: String,
    value: String
}

#[derive(serde::Serialize, Debug)]
struct TestRedisResponse {
    success: bool,
    detail: Option<String>
}

// Use Responder
#[post("/redis", format = "application/json", data = "<data>")]
async fn test_redis(data: Json<TestRedis>, pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>) -> status::Custom<Json<TestRedisResponse>> {
    log::debug!("Got a request: {:?}", data);

    // Send data to Redis
    log::debug!("Sending data to Redis...");
    let mut conn = match pool.get().await {
        Ok(conn) => conn,
        Err(e) => {
            log::error!("Failed to get connection from Redis pool: {}", e);
            // Return status code 500
            return status::Custom(
                Status::InternalServerError,
                Json(TestRedisResponse {
                    success: false,
                    detail: Some(format!("Failed to get connection from Redis pool: {}", e))
                })
            )
        }
    };

    let _: () = match redis::cmd("SET")
        .arg(format!("test_redis-{}", &data.key))
        .arg(&data.value)
        .arg("EX")
        .arg("10")
        .query_async(&mut *conn)
        .await {
            Ok(()) => (),
            Err(e) => {
                log::error!("Failed to send data to Redis: {}", e);
                // Return status code 500
                return status::Custom(
                    Status::InternalServerError,
                    Json(TestRedisResponse {
                        success: false,
                        detail: Some(format!("Failed to send data to Redis: {}", e))
                    })
                )
            }
        };

    log::debug!("Data sent to Redis.");

    status::Custom(
        Status::Ok,
        Json(TestRedisResponse {
            success: true,
            detail: None
        })
    )
}
