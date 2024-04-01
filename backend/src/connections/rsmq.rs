use rsmq_async::{PoolOptions, PooledRsmq, RsmqConnection, RsmqOptions};
use std::env;

use crate::enums::rsmq::RsmqDsQueue;

pub async fn get_pool() -> Result<PooledRsmq, String> {
    let mut pool = match PooledRsmq::new(
        RsmqOptions {
            realtime: false,
            host: match env::var("DS_REDIS_HOST") {
                Ok(var) => var,
                Err(_) => {
                    return Err("Redis host not defined.".into());
                }
            },
            port: match env::var("DS_REDIS_PORT") {
                Ok(var) => {
                    match var.parse::<u16>() {
                        Ok(port) => port,
                        Err(_) => {
                            return Err("Redis port must be a number.".into());
                        }
                    }
                },
                Err(_) => {
                    return Err("Redis port not defined.".into());
                }
            },
            db: match env::var("DS_REDIS_DB") {
                Ok(var) => {
                    match var.parse::<u8>() {
                        Ok(db) => db,
                        Err(_) => {
                            return Err("Redis database must be a number.".into());
                        }
                    }
                },
                Err(_) => {
                    return Err("Redis database not defined.".into());
                }
            },
            username: match env::var("DS_REDIS_USER") {
                Ok(var) => {
                    log::info!("Using Redis username from env.");
                    Some(var)
                },
                Err(_) => {
                    log::info!("No Redis username found in env.");
                    None
                }
            },
            password: match env::var("DS_REDIS_PASSWORD") {
                Ok(var) => {
                    log::info!("Using Redis password from env.");
                    Some(var)
                }
                Err(_) => {
                    log::info!("No Redis password found in env.");
                    None
                }
            },
            ns: match env::var("DS_REDIS_NS") {
                Ok(var) => var,
                Err(_) => {
                    log::info!("Using default DS RSMQ namespace (rsmq).");
                    "rsmq:".to_string()
                }
            }
        },
        PoolOptions {
            max_size: None,
            min_idle: None
        }

    ).await {
        Ok(client) => client,
        Err(e) => {
            return Err(format!("Failed to create RSMQ client: {}", e));
        }
    };

    // Create queues if they don't exist
    let queues: Vec<&str> = vec![
        RsmqDsQueue::BackendWorker.as_str(),
        RsmqDsQueue::BackendWorkerFailed.as_str(),
        RsmqDsQueue::AnalyzeBackendMl.as_str(),
        RsmqDsQueue::AnalyzeBackendMlResp.as_str(),
        RsmqDsQueue::SearchBackendMl.as_str(),
        RsmqDsQueue::SearchBackendMlResp.as_str(),
        RsmqDsQueue::MlMl.as_str(),
        RsmqDsQueue::MlMlResp.as_str(),
        RsmqDsQueue::UploadAnalyzeMl.as_str(),
        RsmqDsQueue::UploadAnalyzeMlResp.as_str()
    ];
    for queue in queues {
        match pool.create_queue(&queue, None, None, None).await {
            Ok(_) => {
                log::info!("Queue {} created.", &queue);
            },
            Err(e) => {
                // If the queue already exists, ignore the error
                if !e.to_string().contains("Queue already exists") {
                    return Err(format!("Failed to create queue {}: {}", &queue, e));
                }
                log::info!("Queue {} already exists.", &queue);
            }
        }
    }

    Ok(pool)
}
