pub enum RsmqDsQueue {
    BackendWorker,
    BackendWorkerFailed,

    AnalyzeBackendMl,
    AnalyzeBackendMlResp,

    SearchBackendMl,
    SearchBackendMlResp,

    MlMl,
    MlMlResp,

    UploadAnalyzeMl,
    UploadAnalyzeMlResp
}
impl RsmqDsQueue {
    pub fn as_str(&self) -> &str {
        match self {
            RsmqDsQueue::BackendWorker => "backend-worker",
            RsmqDsQueue::BackendWorkerFailed => "backend-worker-failed",

            RsmqDsQueue::AnalyzeBackendMl => "analyze-backend-ml",
            RsmqDsQueue::AnalyzeBackendMlResp => "analyze-backend-ml-resp",

            RsmqDsQueue::SearchBackendMl => "search-backend-ml",
            RsmqDsQueue::SearchBackendMlResp => "search-backend-ml-resp",

            RsmqDsQueue::MlMl => "ml-ml",
            RsmqDsQueue::MlMlResp => "ml-ml-resp",

            RsmqDsQueue::UploadAnalyzeMl => "upload-analyze-ml",
            RsmqDsQueue::UploadAnalyzeMlResp => "upload-analyze-ml-resp",
        }
    }
    pub fn from_str(queue: &str) -> Result<RsmqDsQueue, String> {
        match queue {
            "backend-worker" => Ok(RsmqDsQueue::BackendWorker),
            "backend-worker-failed" => Ok(RsmqDsQueue::BackendWorkerFailed),

            "analyze-backend-ml" => Ok(RsmqDsQueue::AnalyzeBackendMl),
            "analyze-backend-ml-resp" => Ok(RsmqDsQueue::AnalyzeBackendMlResp),

            "search-backend-ml" => Ok(RsmqDsQueue::SearchBackendMl),
            "search-backend-ml-resp" => Ok(RsmqDsQueue::SearchBackendMlResp),

            "ml-ml" => Ok(RsmqDsQueue::MlMl),
            "ml-ml-resp" => Ok(RsmqDsQueue::MlMlResp),

            "upload-analyze-ml" => Ok(RsmqDsQueue::UploadAnalyzeMl),
            "upload-analyze-ml-resp" => Ok(RsmqDsQueue::UploadAnalyzeMlResp),

            _ => Err(format!("Invalid queue name: {}", queue))
        }
    }
}
