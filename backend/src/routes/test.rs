use rocket::{
    serde::json::Json,
    http::Status,
    // response::Responder,
    response::status,
    form::Form,
    fs::TempFile
    // State, data::{Limits, ToByteUnit}
};
use rocket::http::{
    ContentType,
    MediaType
};
use log;
use std::{
    path,
    fs
};
// use std::{path, time::Duration};
// use std::fs;
use bb8;
use bb8_redis;
use redis;
use s3::Bucket;

// use crate::models::uploads;


pub fn routes() -> Vec<rocket::Route> {
    routes![
        test_redis,
        test_s3
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

#[derive(FromForm)]
struct TestS3<'f> {
    file: TempFile<'f>,
    tags: Option<String>
}

#[derive(serde::Serialize, Debug)]
struct TestS3Response {
    success: bool,
    detail: Option<String>
}

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

#[post("/s3", format = "multipart/form-data", data = "<form>")]
async fn test_s3(form: Form<TestS3<'_>>, bucket: &rocket::State<Bucket>) -> status::Custom<Json<TestS3Response>> {
    log::debug!("Got a request: {:?}", form.file);

    // Test tags
    match &form.tags {
        Some(tags) => {
            log::debug!("Got tags: {:?}", tags);
        },
        None => {
            log::debug!("No tags provided.");
        }
    }

    // Create a proper file path
    let file_type: &ContentType = match form.file.content_type() {
        Some(t) => t,
        None => {
            log::error!("Failed to get file type.");
            return status::Custom(
                Status::BadRequest,
                Json(TestS3Response {
                    success: false,
                    detail: Some("Failed to get file type.".into())
                })
            );
        }
    };

    let file_name: String;
    let file_path: String;
    {
        let media_type: &MediaType = file_type.media_type();
        let file_hash = crate::utils::hash::hash_file(
            &mut fs::File::open(
                path::Path::new(&form.file.path().unwrap())
            ).unwrap());
        file_name = format!("{}.{}", file_hash, media_type.sub());
        file_path = String::from("tests/") + file_name.as_str();
        log::debug!("File will be saved in S3 as {}", &file_path);
    }

    log::debug!("Sending data to S3...");
    let mut file_buffer = form.file.open().await.unwrap();
    match bucket.put_object_stream(&mut file_buffer, &file_path).await {
        Ok(_) => (),
        Err(e) => {
            log::error!("Failed to send data to S3: {}", e);
            // Return status code 500
            return status::Custom(
                Status::InternalServerError,
                Json(TestS3Response {
                    success: false,
                    detail: Some(format!("Failed to send data to S3: {}", e))
                })
            )
        }
    };

    log::debug!("Data sent to S3.");

    status::Custom(
        Status::Ok,
        Json(TestS3Response {
            success: true,
            detail: None
        })
    )
}
