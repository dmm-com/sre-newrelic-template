// 監視メトリクス：CpuUtilized, CpuReserved
// 内容：CPU使用率を算出。
//
resource "newrelic_nrql_alert_condition" "ecs_cpu_utilization" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ecs_cpu_utilization_alerts)
  name                         = var.ecs_cpu_utilization_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.ecs.containerinsights.CpuUtilized) / average(aws.ecs.containerinsights.CpuReserved) * 100 FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.ecs.containerinsights.ClusterName, aws.ecs.containerinsights.ServiceName"
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：MemoryUtilized, MemoryReserved
// 内容：メモリ使用率を算出。
//
resource "newrelic_nrql_alert_condition" "ecs_memory_used_percent" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ecs_memory_used_percent_alerts)
  name                         = var.ecs_memory_used_percent_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.ecs.containerinsights.MemoryUtilized) / average(aws.ecs.containerinsights.MemoryReserved) * 100 FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.ecs.containerinsights.ClusterName, aws.ecs.containerinsights.ServiceName"
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：RunningTaskCount, DesiredTaskCount
// 内容：タスク正常率を算出。
//
resource "newrelic_nrql_alert_condition" "ecs_task_running_percent" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ecs_task_running_percent_alerts)
  name                         = var.ecs_task_running_percent_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.ecs.containerinsights.RunningTaskCount) / average(aws.ecs.containerinsights.DesiredTaskCount) * 100 FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.ecs.containerinsights.ClusterName, aws.ecs.containerinsights.ServiceName"
  }
  critical {
    operator              = "below"
    threshold             = 100
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：RunningTaskCount
// 内容：現在、RUNNING 状態にあるタスクの数。
//
resource "newrelic_nrql_alert_condition" "ecs_running_task_count" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ecs_running_task_count_alerts)
  name                         = var.ecs_running_task_count_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.ecs.containerinsights.RunningTaskCount) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.ecs.containerinsights.ClusterName, aws.ecs.containerinsights.ServiceName"
  }
  critical {
    operator              = "below"
    threshold             = 2
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}
