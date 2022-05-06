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
ec2_cpu_utilization_alerts = [{
  name      = "[EC2] CPU使用率監視"
  tag_key   = "prod"
  tag_value = "api"
}]
ec2_status_check_failed_alerts = [{
  name      = "[EC2] ステータス監視"
  tag_key   = "prod"
  tag_value = "api"
}]
ec2_cpu_iowait_percent_alerts = [{
  name      = "[EC2] CPU I/O Wait監視"
  tag_key   = "prod"
  tag_value = "api"
}]
ec2_total_utilization_percent_alerts = [{
  name      = "[EC2] ディスクI/O Wait監視"
  tag_key   = "prod"
  tag_value = "api"
}]
ec2_load_average_five_minute_alerts = [{
  name      = "[EC2] ロードアベレージ監視"
  tag_key   = "prod"
  tag_value = "api"
}]
ec2_timesync_alerts = [{
  name      = "ec2 timesync"
  tag_key   = "prod"
  tag_value = "api"
}]
ec2_memory_used_percent_alerts = [{
  name      = "[EC2] メモリ使用率監視"
  tag_key   = "prod"
  tag_value = "api"
}]
ec2_network_bandwidth_used_percent_alerts = [{
  name                     = "ec2 network bandwidth used percent"
  max_limit_bandwidth_mbps = 1000 // 監視対象インスタンスの帯域上限 この場合は 1000mbps
  metrics_interval_minutes = 1    // 拡張メトリクス監視(1分間隔)を使用する場合は 1, それ以外の場合は5分間隔なので 5
  tag_key                  = "prod"
  tag_value                = "api"
}]
ec2_disk_used_percent_alerts = [{
  name      = "[EC2] ディスク使用率監視"
  tag_key   = "prod"
  tag_value = "api"
}]

// RDS alert
rds_alive_alerts = [{
  name      = "rds alive"
  tag_key   = "prod"
  tag_value = "customer"
}]
rds_replica_lag_alerts = [{
  name      = "rds replicalag"
  tag_key   = "prod"
  tag_value = "customer"
}]
// For Aurora
rds_aurora_alive_alerts = [{
  name      = "rds aurora alive"
  tag_key   = "prod"
  tag_value = "customer"
}]
rds_aurora_replica_lag_alerts = [{
  name      = "rds aurora replicalag"
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
