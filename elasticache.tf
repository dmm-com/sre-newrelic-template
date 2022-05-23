// 監視メトリクス：CPUUtilization (Memcached/Redis)
// 内容：ホスト全体の CPU 使用率の割合 (%)。
//
resource "newrelic_nrql_alert_condition" "elasticache_cpu_utilization" {
  policy_id = newrelic_alert_policy.policy.id
  type      = "static"

  description = "Attention <@${var.slack_mention}>"

  name                         = "[ElastiCache] CPU使用率監視"
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(aws.elasticache.CPUUtilization) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.elasticache.CacheClusterId ,aws.elasticache.CacheNodeId"
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：SwapUsage (Memcached/Redis)
// 内容：ホストで使用されるスワップの量。
//
resource "newrelic_nrql_alert_condition" "elasticache_swap_usage" {
  policy_id = newrelic_alert_policy.policy.id
  type      = "static"

  description = "Attention <@${var.slack_mention}>"

  name                         = "[ElastiCache] SWAP使用量監視"
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(aws.elasticache.SwapUsage) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.elasticache.CacheClusterId ,aws.elasticache.CacheNodeId"
  }
  critical {
    operator              = "above"
    threshold             = 50000000 // 50MB
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：FreeableMemory (Memcached/Redis)
// 内容：ホストで使用可能な空きメモリの量。
//
resource "newrelic_nrql_alert_condition" "elasticache_freeable_memory" {
  policy_id = newrelic_alert_policy.policy.id
  type      = "static"

  description = "Attention <@${var.slack_mention}>"

  name                         = "[ElastiCache] 空きメモリ監視"
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(aws.elasticache.FreeableMemory) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.elasticache.CacheClusterId ,aws.elasticache.CacheNodeId"
  }
  critical {
    operator              = "below"
    threshold             = 300000000
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：Evictions (Memcached/Redis)
// 内容1：新しく書き込むための領域を確保するためにキャッシュが排除した、期限切れではない項目の数。 (Memcached)
// 内容2：maxmemory の制限のため排除されたキーの数。 (Redis)
//
resource "newrelic_nrql_alert_condition" "elasticache_evictions" {
  policy_id = newrelic_alert_policy.policy.id
  type      = "static"

  description = "Attention <@${var.slack_mention}>"

  name                         = "[ElastiCache] 排除キー監視"
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(aws.elasticache.Evictions) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.elasticache.CacheClusterId ,aws.elasticache.CacheNodeId"
  }
  critical {
    operator              = "above"
    threshold             = 10
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：CurrConnections (Memcached/Redis)
// 内容1：特定の時点でキャッシュに接続された接続回数。 (Memcached)
// 内容2：リードレプリカからの接続を除く、クライアント接続の数。 (Redis)
//
resource "newrelic_nrql_alert_condition" "elasticache_currconnections" {
  policy_id = newrelic_alert_policy.policy.id
  type      = "static"

  description = "Attention <@${var.slack_mention}>"

  name                         = "[ElastiCache] クライアント接続数監視"
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(aws.elasticache.CurrConnections) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.elasticache.CacheClusterId ,aws.elasticache.CacheNodeId"
  }
  critical {
    operator              = "above"
    threshold             = 100
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：EngineCPUUtilization (Redis)
// 内容：Redis エンジンスレッドの CPU 使用率を提供します。
//
resource "newrelic_nrql_alert_condition" "elasticache_redis_engine_cpu_utilization" {
  policy_id = newrelic_alert_policy.policy.id
  type      = "static"

  description = "Attention <@${var.slack_mention}>"

  name                         = "[ElastiCache] RedisスレッドCPU使用率監視"
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(aws.elasticache.EngineCPUUtilization) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.elasticache.CacheClusterId ,aws.elasticache.CacheNodeId"
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：ReplicationLag (Redis)
// 内容：レプリカのプライマリノードからの変更適用の進行状況を秒で表します。Redis エンジンバージョン 5.0.6 以降では、ラグはミリ秒単位で測定できます。
//
resource "newrelic_nrql_alert_condition" "elasticache_redis_replication_lag" {
  policy_id = newrelic_alert_policy.policy.id
  type      = "static"

  description = "Attention <@${var.slack_mention}>"

  name                         = "[ElastiCache] Redisレプリケーションラグ監視"
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(aws.elasticache.ReplicationLag) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.elasticache.CacheClusterId ,aws.elasticache.CacheNodeId"
  }
  critical {
    operator              = "above"
    threshold             = 10
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：DatabaseMemoryUsagePercentage (Redis)
// 内容：使用中のクラスターで使用中のメモリの割合。
//
resource "newrelic_nrql_alert_condition" "elasticache_redis_database_memory_usage_percentage" {
  policy_id = newrelic_alert_policy.policy.id
  type      = "static"

  description = "Attention <@${var.slack_mention}>"

  name                         = "[ElastiCache] Redisメモリ使用率監視"
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(aws.elasticache.DatabaseMemoryUsagePercentage) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.elasticache.CacheClusterId ,aws.elasticache.CacheNodeId"
  }
  critical {
    operator              = "above"
    threshold             = 80
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}
