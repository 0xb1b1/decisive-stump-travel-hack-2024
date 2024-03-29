use klickhouse::{
    Client,
    ClientOptions
};
use std::env;

pub async fn get_client() -> Result<Client, Box<dyn std::error::Error>> {
    let url = match env::var("DS_CLICKHOUSE_URL") {
        Ok(var) => var,
        Err(_) => {
            return Err("ClickHouse URL not defined.".into());
        }
    };
    let client_options = ClientOptions {
        default_database: match env::var("DS_CLICKHOUSE_DB") {
            Ok(var) => var,
            Err(_) => {
                return Err("ClickHouse database not defined.".into());
            }
        },
        username: match env::var("DS_CLICKHOUSE_USER") {
            Ok(var) => var,
            Err(_) => {
                return Err("ClickHouse username not defined.".into());
            }
        },
        password: match env::var("DS_CLICKHOUSE_PASSWORD") {
            Ok(var) => var,
            Err(_) => {
                return Err("ClickHouse password not defined.".into());
            }
        },
    };

    log::debug!("Connecting to ClickHouse at {}...", &url);

     match Client::connect(
        url,
        client_options
    ).await {
        Ok(client) => {
            return Ok(client);
        },
        Err(e) => {
            return Err(format!("Failed to create ClickHouse client: {}", e).into());
        }
    };
}
