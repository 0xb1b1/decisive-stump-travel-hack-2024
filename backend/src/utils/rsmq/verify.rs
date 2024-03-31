use crate::enums::rsmq::RsmqDsQueue;

pub fn queue_exists(queue: &str) -> bool {
    match RsmqDsQueue::from_str(queue) {
        Ok(_) => true,
        Err(_) => false
    }
}
