resource "newrelic_nrql_alert_condition" "memcached_cpu" {
  policy_id = newrelic_alert_policy.policy.id

  count                        = length(var.elasticache_cpu_alerts)
  name                         = var.elasticache_cpu_alerts[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(aws.elasticache.CPUUtilization) FROM Metric WHERE aws.accountId IN (${var.aws_account_id}) FACET aws.elasticache.CacheClusterId SINCE 30 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 90
  }
}

resource "newrelic_nrql_alert_condition" "memcached_swap" {
  policy_id = newrelic_alert_policy.policy.id

  count                        = length(var.elasticache_swap_alerts)
  name                         = var.elasticache_swap_alerts[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(aws.elasticache.SwapUsage) FROM Metric WHERE aws.accountId IN (${var.aws_account_id}) FACET aws.elasticache.CacheClusterId SINCE 30 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 50000000 // 50MB
  }
}

resource "newrelic_nrql_alert_condition" "memcached_memory" {
  policy_id = newrelic_alert_policy.policy.id

  count                        = length(var.elasticache_memory_alerts)
  name                         = var.elasticache_memory_alerts[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(aws.elasticache.Evictions) FROM Metric WHERE aws.accountId IN (${var.aws_account_id}) FACET aws.elasticache.CacheClusterId SINCE 5 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 0
  }
}
