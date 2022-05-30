data "aws_caller_identity" "self" {}

// 監視メトリクス：CpuUtilized, CpuReserved
// 内容：CPU使用率を算出。
//
resource "newrelic_nrql_alert_condition" "ecs_cpu_utilization" {
  policy_id = var.policy_id
  name      = "[ECS] CPU使用率監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(aws.ecs.containerinsights.CpuUtilized) / average(aws.ecs.containerinsights.CpuReserved) * 100 FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.ecs.containerinsights.ClusterName, aws.ecs.containerinsights.ServiceName"
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <@${var.slack_mention}>"
}

// 監視メトリクス：MemoryUtilized, MemoryReserved
// 内容：メモリ使用率を算出。
//
resource "newrelic_nrql_alert_condition" "ecs_memory_used_percent" {
  policy_id = var.policy_id
  name      = "[ECS] メモリ使用率監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(aws.ecs.containerinsights.MemoryUtilized) / average(aws.ecs.containerinsights.MemoryReserved) * 100 FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.ecs.containerinsights.ClusterName, aws.ecs.containerinsights.ServiceName"
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <@${var.slack_mention}>"
}

// 監視メトリクス：RunningTaskCount, DesiredTaskCount
// 内容：タスク正常率を算出。
//
resource "newrelic_nrql_alert_condition" "ecs_task_running_percent" {
  policy_id = var.policy_id
  name      = "[ECS] タスク正常率監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(aws.ecs.containerinsights.RunningTaskCount) / average(aws.ecs.containerinsights.DesiredTaskCount) * 100 FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.ecs.containerinsights.ClusterName, aws.ecs.containerinsights.ServiceName"
  }
  critical {
    operator              = "below"
    threshold             = 100
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <@${var.slack_mention}>"
}

// 監視メトリクス：RunningTaskCount
// 内容：現在、RUNNING 状態にあるタスクの数。
//
resource "newrelic_nrql_alert_condition" "ecs_running_task_count" {
  policy_id = var.policy_id
  name      = "[ECS] タスク起動数監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(aws.ecs.containerinsights.RunningTaskCount) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.ecs.containerinsights.ClusterName, aws.ecs.containerinsights.ServiceName"
  }
  critical {
    operator              = "below"
    threshold             = 2
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <@${var.slack_mention}>"
}
