// 監視メトリクス：CPUUtilization (Memcached/Redis)
// 内容：ホスト全体の CPU 使用率の割合 (%)。
//
resource "newrelic_nrql_alert_condition" "elasticache_cpu_utilization" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.elasticache_cpu_utilization_alerts)
  name                         = var.elasticache_cpu_utilization_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.elasticache.CPUUtilization) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.elasticache.CacheClusterId ,aws.elasticache.CacheNodeId"
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
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.elasticache_swap_usage_alerts)
  name                         = var.elasticache_swap_usage_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.elasticache.SwapUsage) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.elasticache.CacheClusterId ,aws.elasticache.CacheNodeId"
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
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.elasticache_freeable_memory_alerts)
  name                         = var.elasticache_freeable_memory_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.elasticache.FreeableMemory) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.elasticache.CacheClusterId ,aws.elasticache.CacheNodeId"
  }
  critical {
    operator              = "below"
    threshold             = 300
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：Evictions (Memcached/Redis)
// 内容1：新しく書き込むための領域を確保するためにキャッシュが排除した、期限切れではない項目の数。 (Memcached)
// 内容2：maxmemory の制限のため排除されたキーの数。 (Redis)
//
resource "newrelic_nrql_alert_condition" "elasticache_evictions" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.elasticache_evictions_alerts)
  name                         = var.elasticache_evictions_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.elasticache.Evictions) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.elasticache.CacheClusterId ,aws.elasticache.CacheNodeId"
  }
  critical {
    operator              = "above"
    threshold             = 10
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}
