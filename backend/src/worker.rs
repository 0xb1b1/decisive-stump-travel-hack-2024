use std::time::Duration;
use async_std::task;

mod connections;
mod enums;

#[tokio::main]
async fn main() {
    env_logger::init();

    log::info!("Creating RSMQ pool...");
    // RSMQ uses a built-in connection pool
    let rsmq_pool = connections::rsmq::get_pool().await.unwrap();
    log::info!("Created RSMQ pool.");

    loop {
        log::info!("Checking RSMQ...");

        task::sleep(Duration::from_secs(10)).await;
    }
}
