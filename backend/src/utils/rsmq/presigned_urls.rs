use rsmq_async::{PooledRsmq, RsmqConnection};

use crate::{enums::{rsmq::RsmqDsQueue, worker::TaskType}, models::http::images::S3PresignedUrls};


async fn get_s3_presigned_urls_redis(
    filename: &str,
    redis_pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
) -> Option<S3PresignedUrls> {
    let mut redis_conn = match redis_pool.get().await {
        Ok(conn) => conn,
        Err(e) => {
            log::error!("Failed to get connection from Redis pool: {}", e);
            return None;
        }
    };

    let maybe_urls: Option<S3PresignedUrls> = match redis::cmd("GET")
        .arg(format!("images:presigned_urls:{}", filename))
        .query_async::<_, Option<String>>(&mut *redis_conn)
        .await
    {
        Ok(url) => {
            match url {
                Some(url) => {
                    log::info!("Presigned URLs found in Redis: {}", url);
                    serde_json::from_str(&url).unwrap()
                }
                None => None,
            }
        }
        Err(e) => {
            log::error!("Failed to get presigned URLs from Redis: {}", e);
            return None;
        }
    };

    maybe_urls
}

pub async fn get_s3_presigned_urls_direct(
    filename: &str,
    expiry_secs: Option<u32>,
    redis_pool: &rocket::State<bb8::Pool<bb8_redis::RedisConnectionManager>>,
    rsmq_pool: &rocket::State<PooledRsmq>,
    timeout_secs: u32,
) -> Result<S3PresignedUrls, String> {
    // Checks if presigned URLs are set in Redis.
    // If not, sends a request to the worker and waits for
    // the aforementioned key.

    let final_expiry_secs = match expiry_secs {
        Some(expiry_secs) => expiry_secs,
        None => 3600,
    };

    let maybe_urls = get_s3_presigned_urls_redis(filename, redis_pool).await;

    if let Some(urls) = maybe_urls {
        return Ok(urls);
    } else {
        // Send a message to the worker to get the presigned URLs.
        let _ = match rsmq_pool
            .inner()
            .clone()
            .send_message(
                RsmqDsQueue::BackendWorker.as_str(),
                serde_json::to_string(
                    &TaskType::GenS3PresignedUrls {
                        filename: filename.to_string(),
                        expiry_secs: final_expiry_secs,
                    }
                ).unwrap().as_str(),
                None,
        ).await {
            Ok(_) => {
                log::info!("Sent message to worker to get presigned URLs");
            }
            Err(e) => {
                log::error!("Failed to send message to worker: {}", e);
                return Err(format!("Failed to send message to worker: {}", e).into());
            }
        };

        // Wait for the worker to finish the task.
        let mut timeout_counter = timeout_secs.clone();
        loop {
            let maybe_urls = get_s3_presigned_urls_redis(filename, redis_pool).await;

            if let Some(urls) = maybe_urls {
                return Ok(urls);
            }

            log::debug!("Waiting for the worker to finish the task (attempts remaining: {})", timeout_counter);

            if timeout_counter == 0 {
                return Err("Timeout while waiting for the worker to finish the task".into());
            }

            timeout_counter -= 1;
            tokio::time::sleep(tokio::time::Duration::from_secs(1)).await;
        }
    }
}
