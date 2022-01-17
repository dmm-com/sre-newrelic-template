resource "newrelic_nrql_alert_condition" "memcached_cpu" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  count                        = length(var.elasticache_cpu_alerts)
  name                         = var.elasticache_cpu_alerts[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(aws.elasticache.CPUUtilization) FROM Metric WHERE aws.accountId IN (${var.aws_account_id}) FACET aws.elasticache.CacheClusterId ,aws.elasticache.CacheNodeId"
    evaluation_offset = 3
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "memcached_swap" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  count                        = length(var.elasticache_swap_alerts)
  name                         = var.elasticache_swap_alerts[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(aws.elasticache.SwapUsage) FROM Metric WHERE aws.accountId IN (${var.aws_account_id}) FACET aws.elasticache.CacheClusterId ,aws.elasticache.CacheNodeId"
    evaluation_offset = 3
  }
  critical {
    operator              = "above"
    threshold             = 50000000 // 50MB
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "memcached_memory" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  count                        = length(var.elasticache_memory_alerts)
  name                         = var.elasticache_memory_alerts[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(aws.elasticache.FreeableMemory) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.elasticache.CacheClusterId ,aws.elasticache.CacheNodeId"
    evaluation_offset = 3
  }
  critical {
    operator              = "below"
    threshold             = 300
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}
