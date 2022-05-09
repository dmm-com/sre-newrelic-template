// 監視メトリクス：ReplicaLag (RDS)
// 内容：レプリカ遅延 (ミリ秒)
//
resource "newrelic_nrql_alert_condition" "rds_replica_lag" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.rds_replica_lag_alerts)
  name                         = var.rds_replica_lag_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.rds.ReplicaLag) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) AND tags.${var.rds_replica_lag_alerts[count.index].tag_key} = '${var.rds_replica_lag_alerts[count.index].tag_value}' FACET aws.rds.DBInstanceIdentifier"
  }
  critical {
    operator           = "above"
    threshold          = 1
    threshold_duration = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：AuroraReplicaLag (Aurora)
// 内容：Aurora でのレプリカ遅延 (ミリ秒)
//
resource "newrelic_nrql_alert_condition" "rds_aurora_replica_lag" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.rds_aurora_replica_lag_alerts)
  name                         = var.rds_aurora_replica_lag_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.rds.AuroraReplicaLag) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${data.aws_caller_identity.self.account_id}) AND tags.${var.rds_aurora_replica_lag_alerts[count.index].tag_key} = '${var.rds_aurora_replica_lag_alerts[count.index].tag_value}' FACET entityName"
  }
  critical {
    operator           = "above"
    threshold          = 1000 // 1sec
    threshold_duration = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：CPUUtilization (RDS/Aurora)
// 内容：CPU 使用率。
//
resource "newrelic_nrql_alert_condition" "rds_cpu_utilization" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.rds_cpu_utilization_alerts)
  name                         = var.rds_cpu_utilization_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.rds.CPUUtilization) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${data.aws_caller_identity.self.account_id}) AND tags.${var.rds_cpu_utilization_alerts[count.index].tag_key} = '${var.rds_cpu_utilization_alerts[count.index].tag_value}' FACET entityName"
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：FreeableMemory (RDS/Aurora)
// 内容：使用可能な RAM の容量。
//
resource "newrelic_nrql_alert_condition" "rds_freeable_memory" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.rds_freeable_memory_alerts)
  name                         = var.rds_freeable_memory_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.rds.FreeableMemory) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${data.aws_caller_identity.self.account_id}) AND tags.${var.rds_freeable_memory_alerts[count.index].tag_key} = '${var.rds_freeable_memory_alerts[count.index].tag_value}' FACET entityName"
  }
  critical {
    operator              = "below"
    threshold             = 500000000
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：FreeLocalStorage (RDS/Aurora)
// 内容1：使用できるローカルストレージスペースの量。マルチ AZ の DB クラスターにのみ適用されます。 (RDS)
// 内容2：使用できるローカルストレージの量。 (Aurora)
//
resource "newrelic_nrql_alert_condition" "rds_free_local_storage" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.rds_free_local_storage_alerts)
  name                         = var.rds_free_local_storage_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.rds.FreeLocalStorage) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${data.aws_caller_identity.self.account_id}) AND tags.${var.rds_free_local_storage_alerts[count.index].tag_key} = '${var.rds_free_local_storage_alerts[count.index].tag_value}' FACET entityName"
  }
  critical {
    operator              = "below"
    threshold             = 10000000000
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：DatabaseConnections (RDS/Aurora)
// 内容：データベースインスタンスへのクライアントネットワーク接続の数。
//
resource "newrelic_nrql_alert_condition" "rds_database_connections" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.rds_database_connections_alerts)
  name                         = var.rds_database_connections_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.rds.DatabaseConnections) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${data.aws_caller_identity.self.account_id}) AND tags.${var.rds_database_connections_alerts[count.index].tag_key} = '${var.rds_database_connections_alerts[count.index].tag_value}' FACET entityName"
  }
  critical {
    operator              = "above"
    threshold             = 100
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

