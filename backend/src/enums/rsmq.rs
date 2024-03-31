pub enum RsmqDsQueue {
    AnalyzeBackendMl,
    AnalyzeBackendMlResp,
    SearchBackendMl,
    SearchBackendMlResp,
    MlMl,
    MlMlResp
}
impl RsmqDsQueue {
    pub fn to_str(&self) -> &str {
        match self {
            RsmqDsQueue::AnalyzeBackendMl => "analyze-backend-ml",
            RsmqDsQueue::AnalyzeBackendMlResp => "analyze-backend-ml-resp",
            RsmqDsQueue::SearchBackendMl => "search-backend-ml",
            RsmqDsQueue::SearchBackendMlResp => "search-backend-ml-resp",
            RsmqDsQueue::MlMl => "ml-ml",
            RsmqDsQueue::MlMlResp => "ml-ml-resp"
        }
    }
    pub fn from_str(queue: &str) -> Result<RsmqDsQueue, String> {
        match queue {
            "analyze-backend-ml" => Ok(RsmqDsQueue::AnalyzeBackendMl),
            "analyze-backend-ml-resp" => Ok(RsmqDsQueue::AnalyzeBackendMlResp),
            "search-backend-ml" => Ok(RsmqDsQueue::SearchBackendMl),
            "search-backend-ml-resp" => Ok(RsmqDsQueue::SearchBackendMlResp),
            "ml-ml" => Ok(RsmqDsQueue::MlMl),
            "ml-ml-resp" => Ok(RsmqDsQueue::MlMlResp),
            _ => Err(format!("Invalid queue name: {}", queue))
        }
    }
}