use clickhouse::Client;
use std::env;

pub fn get_client() -> Result<Client, String> {
    let client = Client::default()
        .with_url(match env::var("DS_CLICKHOUSE_URL"){
            Ok(var) => var,
            Err(_) => {
                return Err("ClickHouse URL not defined.".into());
            }
        })
        .with_database(match env::var("DS_CLICKHOUSE_DB"){
            Ok(var) => var,
            Err(_) => {
                return Err("ClickHouse DB not defined.".into());
            }
        })
        .with_user(match env::var("DS_CLICKHOUSE_USER"){
            Ok(var) => var,
            Err(_) => {
                return Err("ClickHouse User not defined.".into());
            }
        })
        .with_password(match env::var("DS_CLICKHOUSE_PASSWORD"){
            Ok(var) => var,
            Err(_) => {
                return Err("ClickHouse Password not defined.".into());
            }
        });

    return Ok(client)
}
