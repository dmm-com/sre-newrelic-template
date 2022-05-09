nr_account_id  = // 数値型
nr_api_key     = "" // Type:USERのAPIキー
nr_external_id = // 数値型

aws_region     = "ap-northeast-1"
aws_access_key = ""
aws_secret_key = ""

slack_mention  = ""

// -------------------------------------------
// Synthetics
// -------------------------------------------
newrelic_synthetics_ping = [
  {
    name                      = "TopPage"
    status                    = "ENABLED"
    uri                       = "https://dmm.com/"
    validation_string         = "" // レスポンスが正しいかチェックする時用のバリデーション文字列
    verify_ssl                = true
    bypass_head_request       = false // pingチェックのときデフォルトのHEADリクエストをスキップし、代わりにGETリクエストを使用する
    treat_redirect_as_failure = true
  },
  {
    name                      = "hugaping"
    status                    = "ENABLED"
    uri                       = "http://fugafuga.com"
    validation_string         = "test"
    verify_ssl                = false
    bypass_head_request       = false
    treat_redirect_as_failure = false
  }
]

newrelic_synthetics_browser = [
  {
    name                = "TopPage"
    status              = "ENABLED"
    uri                 = "https://www.dmm.com"
    validation_string   = "Welcome to DMM.com!"
    verify_ssl          = true
    bypass_head_request = false
  },
  {
    name                = "fugasynbrowser"
    status              = "ENABLED"
    uri                 = "http://fugafuga.com"
    validation_string   = "test"
    verify_ssl          = false
    bypass_head_request = false
  }
]

// -------------------------------------------
// Alart
// -------------------------------------------
alert_policy_name = "prodAlert"

alert_slack_channel = {
  name    = "prodAlertSlack"
  url     = "" // slack hook url
  channel = "" // Team Channel用
}

// EC2 alerts
ec2_cpu_alerts = [{
  name      = "ec2 cpu"
  tag_key   = "prod"
  tag_value = "api"
}]
ec2_alive_alerts = [{
  name      = "ec2 alive"
  tag_key   = "prod"
  tag_value = "api"
}]
ec2_cpuiowait_alerts = [{
  name      = "ec2 cpuiowait"
  tag_key   = "prod"
  tag_value = "api"
}]
ec2_disk_alerts = [{
  name      = "ec2 disk"
  tag_key   = "prod"
  tag_value = "api"
}]
ec2_load_average_alerts = [{
  name      = "ec2 load average"
  tag_key   = "prod"
  tag_value = "api"
}]
ec2_timesync_alerts = [{
  name      = "ec2 timesync"
  tag_key   = "prod"
  tag_value = "api"
}]
ec2_memory_alerts = [{
  name      = "ec2 memory"
  tag_key   = "prod"
  tag_value = "api"
}]
ec2_network_alerts = [{
  name                     = "ec2 network"
  max_limit_bandwidth_mbps = 1000 // 監視対象インスタンスの帯域上限 この場合は 1000mbps
  metrics_interval_minutes = 1    // 拡張メトリクス監視(1分間隔)を使用する場合は 1, それ以外の場合は5分間隔なので 5
  tag_key                  = "prod"
  tag_value                = "api"
}]

// RDS/Aurora alert
rds_replica_lag_alerts = [{
  name      = "[RDS] レプリカ同期遅延監視"
  tag_key   = "prod"
  tag_value = "customer"
}]
rds_aurora_replica_lag_alerts = [{
  name      = "[Aurora] レプリカ同期遅延監視"
  tag_key   = "prod"
  tag_value = "customer"
}]
rds_cpu_utilization_alerts = [{
  name      = "[RDS/Aurora] CPU使用率監視"
  tag_key   = "prod"
  tag_value = "customer"
}]
rds_freeable_memory_alerts = [{
  name      = "[RDS/Aurora] メモリ空き容量監視"
  tag_key   = "prod"
  tag_value = "customer"
}]
rds_free_local_storage_alerts = [{
  name      = "[RDS/Aurora] ローカルストレージ空き容量監視"
  tag_key   = "prod"
  tag_value = "customer"
}]
rds_database_connections_alerts = [{
  name      = "[RDS/Aurora] データベース接続数監視"
  tag_key   = "prod"
  tag_value = "customer"
}]
rds_blocked_transactions_alerts = [{
  name      = "[Aurora] ブロックトランザクション数監視"
  tag_key   = "prod"
  tag_value = "customer"
}]
rds_deadlocks_alerts = [{
  name      = "[Aurora] デッドロック数監視"
  tag_key   = "prod"
  tag_value = "customer"
}]

// Elasticache alerts
elasticache_cpu_alerts = [{
  name = "elasticache cpu"
}]
elasticache_swap_alerts = [{
  name = "elasticache swap"
}]
elasticache_memory_alerts = [{
  name = "elasticache memory"
}]

// CloudFront alerts
cloudfront_4xx_alerts = [{
  name = "cloudfront 4xx"
}]
cloudfront_5xx_alerts = [{
  name = "cloudfront 5xx"
}]
cloudfront_origin_latency_alerts = [{
  name = "cloudfront origin latency"
}]
