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
}]
ec2_status_check_failed_alerts = [{
  name      = "[EC2] ステータス監視"
}]
ec2_cpu_iowait_percent_alerts = [{
  name      = "[EC2] CPU I/O Wait監視"
}]
ec2_total_utilization_percent_alerts = [{
  name      = "[EC2] ディスクI/O Wait監視"
}]
ec2_load_average_five_minute_alerts = [{
  name      = "[EC2] ロードアベレージ監視"
}]
ec2_timesync_alerts = [{
  name      = "[EC2] 時刻同期監視"
}]
ec2_memory_used_percent_alerts = [{
  name      = "[EC2] メモリ使用率監視"
}]
ec2_network_bandwidth_used_percent_alerts = [{
  name                     = "[EC2] ネットワーク帯域使用率監視"
  max_limit_bandwidth_mbps = 1000 // 監視対象インスタンスの帯域上限 この場合は 1000mbps
  metrics_interval_minutes = 1    // 拡張メトリクス監視(1分間隔)を使用する場合は 1, それ以外の場合は5分間隔なので 5
}]
ec2_disk_used_percent_alerts = [{
  name      = "[EC2] ディスク使用率監視"
}]
ec2_inodes_used_percent_alerts = [{
  name      = "[EC2] iノード使用率監視"
}]

// RDS/Aurora alert
rds_replica_lag_alerts = [{
  name      = "[RDS] レプリカ同期遅延監視"
}]
rds_aurora_replica_lag_alerts = [{
  name      = "[Aurora] レプリカ同期遅延監視"
}]
rds_cpu_utilization_alerts = [{
  name      = "[RDS/Aurora] CPU使用率監視"
}]
rds_freeable_memory_alerts = [{
  name      = "[RDS/Aurora] メモリ空き容量監視"
}]
rds_free_local_storage_alerts = [{
  name      = "[RDS/Aurora] ローカルストレージ空き容量監視"
}]
rds_database_connections_alerts = [{
  name      = "[RDS/Aurora] データベース接続数監視"
}]
rds_blocked_transactions_alerts = [{
  name      = "[Aurora] ブロックトランザクション数監視"
}]
rds_deadlocks_alerts = [{
  name      = "[Aurora] デッドロック数監視"
}]
rds_free_storage_space_alerts = [{
  name      = "[RDS] ストレージ空き容量監視"
}]
rds_swap_usage_alerts = [{
  name      = "[RDS] SWAP使用量監視"
}]
rds_network_receive_throughput_alerts = [{
  name      = "[RDS/Aurora] 死活監視（データ受信）"
}]
rds_network_transmit_throughput_alerts = [{
  name      = "[RDS/Aurora] 死活監視（データ送信）"
}]

// Elasticache alerts
elasticache_cpu_utilization_alerts = [{
  name = "[ElastiCache] CPU使用率監視"
}]
elasticache_swap_usage_alerts = [{
  name = "[ElastiCache] SWAP使用量監視"
}]
elasticache_freeable_memory_alerts = [{
  name = "[ElastiCache] 空きメモリ監視"
}]
elasticache_evictions_alerts = [{
  name = "[ElastiCache] 排除キー監視"
}]
elasticache_currconnections_alerts = [{
  name = "[ElastiCache] クライアント接続数監視"
}]
elasticache_redis_engine_cpu_utilization_alerts = [{
  name = "[ElastiCache] RedisスレッドCPU使用率監視"
}]
elasticache_redis_replication_lag_alerts = [{
  name = "[ElastiCache] Redisレプリケーションラグ監視"
}]
elasticache_redis_database_memory_usage_percentage_alerts = [{
  name = "[ElastiCache] Redisメモリ使用率監視"
}]

// CloudFront alerts
cloudfront_4xx_error_rate_alerts = [{
  name = "[CloudFront] 4xx エラー率監視"
}]
cloudfront_5xx_error_rate_alerts = [{
  name = "[CloudFront] 5xx エラー率監視"
}]
cloudfront_origin_latency_alerts = [{
  name = "[CloudFront] オリジン遅延監視"
}]

// ELB alerts
elb_http_code_elb_5xx_count_alerts = [{
  name = "[ALB] LB 5xx エラー数監視"
}]
elb_rejected_connection_count_alerts = [{
  name = "[ALB] LB リクエスト拒否数監視"
}]
elb_http_code_target_5xx_count_alerts = [{
  name = "[ALB] Target 5xx エラー数監視"
}]
elb_target_connection_error_count_alerts = [{
  name = "[ALB] Target 接続確立エラー数監視"
}]
elb_alb_unhealthy_host_count_alerts = [{
  name = "[ALB] Target 異常数監視"
}]
elb_port_allocation_error_count_alerts = [{
  name = "[NLB] ポート割り当てエラー数監視"
}]
elb_nlb_unhealthy_host_count_alerts = [{
  name = "[NLB] Target 異常数監視"
}]

// NatGateway alerts
natgateway_packets_drop_count_alerts = [{
  name = "[NAT Gateway] パケットドロップ監視"
}]
natgateway_error_port_allocation_alerts = [{
  name = "[NAT Gateway] ポート割り当てエラー監視"
}]

// ECS alerts
ecs_cpu_utilization_alerts = [{
  name = "[ECS] CPU使用率監視"
}]
ecs_memory_used_percent_alerts = [{
  name = "[ECS] メモリ使用率監視"
}]
ecs_task_running_percent_alerts = [{
  name = "[ECS] タスク正常率監視"
}]
ecs_running_task_count_alerts = [{
  name = "[ECS] タスク起動数監視"
}]
