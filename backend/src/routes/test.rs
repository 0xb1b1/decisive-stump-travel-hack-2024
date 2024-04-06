use ds_travel_hack_2024::models::http::images::S3PresignedUrls;
// use ds_travel_hack_2024::utils::redis::images::get_s3_presigned_urls;
use ds_travel_hack_2024::utils::rsmq::presigned_urls::get_s3_presigned_urls_direct;
use log;
use rocket::http::{ContentType, MediaType};
use rocket::{
    form::Form,
    fs::TempFile, // State, data::{Limits, ToByteUnit}
    http::Status,
    // response::Responder,
    response::status,
    serde::json::Json,
};
// use s3::serde_types::ListBucketResult;
use tokio::io::AsyncReadExt;
// use std::{path, time::Duration};
// use std::fs;
use bb8;
use bb8_redis;
use redis;
use rsmq_async::{PooledRsmq, RsmqConnection};
use s3::Bucket;
// use crate::enums::rsmq::RsmqDsQueue;
use ds_travel_hack_2024::utils;

use crate::config::DsConfig;

// use crate::models::uploads;

pub fn routes() -> Vec<rocket::Route> {
    routes![
        test_redis,
        test_s3,
        test_rsmq_send,
        test_rsmq_receive,
        test_list_s3_files,
        test_get_presigned_urls,
    ]
}

#[derive(serde::Deserialize, Debug)]
struct TestRedis {
    key: String,
    value: String,
}

#[derive(serde::Serialize, Debug)]
struct TestRedisResponse {
    success: bool,
    detail: Option<String>,
}

#[derive(FromForm)]
struct TestS3<'f> {
    file: TempFile<'f>,
    tags: Option<String>,
}

#[derive(serde::Serialize, Debug)]
struct TestS3Response {
    success: bool,
    detail: Option<String>,
}

#[derive(serde::Deserialize, Debug)]
struct TestRsmq {
    queue_name: String,
    message: String,
}

#[derive(serde::Serialize, Debug)]
struct TestRsmqResponse {
    success: bool,
    queue_id: Option<String>,
    detail: Option<String>,
}

#[derive(serde::Deserialize, Debug)]
struct TestRsmqReceive {
    queue_name: String,
}

#[derive(serde::Serialize, Debug)]
struct TestRsmqReceiveResponse {
    success: bool,
    message: Option<String>,
    detail: Option<String>,
}

#[derive(serde::Serialize, Debug)]
struct TestListS3FilesResponse {
    files: Option<Vec<String>>,
    count: Option<usize>,
}

#[post("/redis", format = "application/json", data = "<data>")]
async fn test_redis(
    data: Json<TestRedis>,
    pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
) -> status::Custom<Json<TestRedisResponse>> {
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
                    detail: Some(format!("Failed to get connection from Redis pool: {}", e)),
                }),
            );
        }
    };

    let _: () = match redis::cmd("SET")
        .arg(format!("test:redis:{}", &data.key))
        .arg(&data.value)
        .arg("EX")
        .arg("10")
        .query_async(&mut *conn)
        .await
    {
        Ok(()) => (),
        Err(e) => {
            log::error!("Failed to send data to Redis: {}", e);
            // Return status code 500
            return status::Custom(
                Status::InternalServerError,
                Json(TestRedisResponse {
                    success: false,
                    detail: Some(format!("Failed to send data to Redis: {}", e)),
                }),
            );
        }
    };

    log::debug!("Data sent to Redis.");

    status::Custom(
        Status::Ok,
        Json(TestRedisResponse {
            success: true,
            detail: None,
        }),
    )
}

#[post("/s3", format = "multipart/form-data", data = "<form>")]
async fn test_s3(
    form: Form<TestS3<'_>>,
    bucket: &rocket::State<Bucket>,
) -> status::Custom<Json<TestS3Response>> {
    log::debug!("Got a request: {:?}", form.file);

    // Test tags
    match &form.tags {
        Some(tags) => {
            log::debug!("Got tags: {:?}", tags);
        }
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
                    detail: Some("Failed to get file type.".into()),
                }),
            );
        }
    };

    // Create a proper file path
    let mut file_buffer: Vec<u8> = Vec::new();
    form.file
        .open()
        .await
        .unwrap()
        .read_buf(&mut file_buffer)
        .await
        .unwrap();

    let file_name: String;
    let file_path: String;
    {
        let media_type: &MediaType = file_type.media_type();
        let file_hash = ds_travel_hack_2024::utils::hash::hash_file(&file_buffer);

        let file_ext;
        if media_type.sub() == "jpeg" {
            file_ext = "jpg";
        } else {
            file_ext = media_type.sub().as_str();
        }

        file_name = format!("{}.{}", file_hash, file_ext);
        file_path = file_name.clone(); // For flexibility
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
                    detail: Some(format!("Failed to send data to S3: {}", e)),
                }),
            );
        }
    };

    log::debug!("Data sent to S3.");

    status::Custom(
        Status::Ok,
        Json(TestS3Response {
            success: true,
            detail: None,
        }),
    )
}

#[post("/rsmq/send", data = "<data>")]
async fn test_rsmq_send(
    data: Json<TestRsmq>,
    pool: &rocket::State<PooledRsmq>,
) -> status::Custom<Json<TestRsmqResponse>> {
    log::debug!("Got a request: {:?}", data);

    // Verify queue name
    if !utils::rsmq::verify::queue_exists(data.queue_name.as_str()) {
        log::error!("Queue name is invalid.");
        return status::Custom(
            Status::BadRequest,
            Json(TestRsmqResponse {
                success: false,
                queue_id: None,
                detail: Some("Queue name is invalid.".into()),
            }),
        );
    }

    // Send data to RSMQ
    log::debug!("Sending data to RSMQ...");
    let queue_id = match pool
        .inner()
        .clone()
        .send_message(data.queue_name.as_str(), data.message.as_str(), None)
        .await
    {
        Ok(msg) => msg,
        Err(e) => {
            log::error!("Failed to send data to RSMQ: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(TestRsmqResponse {
                    success: false,
                    queue_id: None,
                    detail: Some(format!("Failed to send data to RSMQ: {}", e)),
                }),
            );
        }
    };

    status::Custom(
        Status::Ok,
        Json(TestRsmqResponse {
            success: true,
            queue_id: Some(queue_id),
            detail: None,
        }),
    )
}

#[post("/rsmq/receive", data = "<data>")]
async fn test_rsmq_receive(
    data: Json<TestRsmqReceive>,
    pool: &rocket::State<PooledRsmq>,
) -> status::Custom<Json<TestRsmqReceiveResponse>> {
    log::debug!("Got a request: {:?}", data);

    // Verify queue name
    if !utils::rsmq::verify::queue_exists(data.queue_name.as_str()) {
        log::error!("Queue name is invalid.");
        return status::Custom(
            Status::BadRequest,
            Json(TestRsmqReceiveResponse {
                success: false,
                message: None,
                detail: Some("Queue name is invalid.".into()),
            }),
        );
    }

    // Receive data from RSMQ
    log::debug!("Receiving data from RSMQ...");
    let message = match pool
        .inner()
        .clone()
        .receive_message(data.queue_name.as_str(), None)
        .await
    {
        Ok(msg) => {
            let msg = match msg {
                Some(m) => m,
                None => {
                    log::error!("Failed to receive data from RSMQ: No message received.");
                    return status::Custom(
                        Status::InternalServerError,
                        Json(TestRsmqReceiveResponse {
                            success: false,
                            message: None,
                            detail: Some(
                                "Failed to receive data from RSMQ: No message received.".into(),
                            ),
                        }),
                    );
                }
            };
            log::debug!("Removing message from RSMQ: {:?}", msg);
            pool.inner()
                .clone()
                .delete_message(data.queue_name.as_str(), &msg.id)
                .await
                .unwrap();
            log::debug!("Message removed from Redis: {:?}", msg);
            msg
        }
        Err(e) => {
            log::error!("Failed to receive data from RSMQ: {}", e);
            return status::Custom(
                Status::InternalServerError,
                Json(TestRsmqReceiveResponse {
                    success: false,
                    message: None,
                    detail: Some(format!("Failed to receive data from RSMQ: {}", e)),
                }),
            );
        }
    };

    status::Custom(
        Status::Ok,
        Json(TestRsmqReceiveResponse {
            success: true,
            message: Some(message.message),
            detail: None,
        }),
    )
}

#[get("/s3/list")]
async fn test_list_s3_files(
    bucket: &rocket::State<Bucket>,
) -> status::Custom<Json<TestListS3FilesResponse>> {
    let mut filenames = Vec::new();
    let list = bucket
        .list(String::default(), Some("/".to_string()))
        .await
        .unwrap();
    for bucket in list {
        for object in bucket.contents {
            filenames.push(object.key);
        }
    }

    status::Custom(
        Status::Ok,
        Json(TestListS3FilesResponse {
            files: Some(filenames.clone()),
            count: Some(filenames.len()),
        }),
    )
}

#[get("/img/presigned_urls?<filename>")]
async fn test_get_presigned_urls(
    filename: &str,
    redis_pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
    rsmq_pool: &rocket::State<PooledRsmq>,
    config: &rocket::State<DsConfig>,
) -> status::Custom<Json<S3PresignedUrls>> {
    match get_s3_presigned_urls_direct(
        filename,
        None,
        redis_pool,
        rsmq_pool,
        config.s3_get_presigned_urls_timeout_secs,
    )
    .await
    {
        Ok(urls) => {
            log::debug!(
                "Successfully received S3PresignedUrls for filename: {}",
                filename
            );
            status::Custom(Status::Ok, Json(urls))
        }
        Err(err) => {
            log::error!("An error occurred when generating S3PresignedUrl: {}", err);
            status::Custom(Status::InternalServerError, Json(S3PresignedUrls::new()))
        }
    }
}
