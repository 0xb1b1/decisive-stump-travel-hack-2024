use rsmq_async::PooledRsmq;
use rsmq_async::RsmqConnection;

use crate::enums::{rsmq::RsmqDsQueue, worker::TaskType};

pub async fn send_to_error_queue(task: &TaskType, rsmq_pool: &mut PooledRsmq) -> Result<(), ()> {
    match rsmq_pool.send_message(
        RsmqDsQueue::BackendWorkerFailed.as_str(),
        serde_json::to_string(&task).unwrap(),
        None,
    ).await {
        Ok(_) => {
            log::info!("Sent message to RSMQ failed queue.");
            Ok(())
        }
        Err(err) => {
            log::error!("Failed to send message to RSMQ failed queue: {}", err);
            Err(())
        }
    }
}
