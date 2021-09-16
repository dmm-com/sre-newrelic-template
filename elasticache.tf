resource "newrelic_nrql_alert_condition" "memcached_cpu" {
  policy_id = newrelic_alert_policy.policy.id

  count                        = length(var.elasticache_cpu_alert_names)
  name                         = var.elasticache_cpu_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(aws.elasticache.CPUUtilization) FROM Metric FACET aws.elasticache.CacheClusterId WHERE aws.accountId IN (${var.aws_account_id}) SINCE 30 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 90
  }
}

resource "newrelic_nrql_alert_condition" "memcached_swap" {
  policy_id = newrelic_alert_policy.policy.id

  count                        = length(var.elasticache_swap_alert_names)
  name                         = var.elasticache_swap_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(aws.elasticache.SwapUsage) FROM Metric FACET aws.elasticache.CacheClusterId WHERE aws.accountId IN (${var.aws_account_id}) SINCE 30 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 50000000 // 50MB
  }
}

resource "newrelic_nrql_alert_condition" "memcached_memory" {
  policy_id = newrelic_alert_policy.policy.id

  count                        = length(var.elasticache_memory_alert_names)
  name                         = var.elasticache_memory_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(aws.elasticache.Evictions) FROM Metric FACET aws.elasticache.CacheClusterId WHERE aws.accountId IN (${var.aws_account_id}) SINCE 5 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 0
  }
}
