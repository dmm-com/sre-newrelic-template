// 監視メトリクス：ReplicaLag (RDS)
// 内容：レプリカ遅延 (ミリ秒)
//
resource "newrelic_nrql_alert_condition" "rds_replica_lag" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.rds_replica_lag_alerts)
  name                         = var.rds_replica_lag_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.rds.ReplicaLag) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.rds.DBInstanceIdentifier"
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

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.rds_aurora_replica_lag_alerts)
  name                         = var.rds_aurora_replica_lag_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.rds.AuroraReplicaLag) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.rds.DBClusterIdentifier, aws.rds.DBInstanceIdentifier"
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

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.rds_cpu_utilization_alerts)
  name                         = var.rds_cpu_utilization_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.rds.CPUUtilization) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.rds.DBClusterIdentifier, aws.rds.DBInstanceIdentifier"
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

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.rds_freeable_memory_alerts)
  name                         = var.rds_freeable_memory_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.rds.FreeableMemory) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.rds.DBClusterIdentifier, aws.rds.DBInstanceIdentifier"
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

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.rds_free_local_storage_alerts)
  name                         = var.rds_free_local_storage_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.rds.FreeLocalStorage) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.rds.DBClusterIdentifier, aws.rds.DBInstanceIdentifier"
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

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.rds_database_connections_alerts)
  name                         = var.rds_database_connections_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.rds.DatabaseConnections) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.rds.DBClusterIdentifier, aws.rds.DBInstanceIdentifier"
  }
  critical {
    operator              = "above"
    threshold             = 100
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：BlockedTransactions (Aurora)
// 内容：1 秒あたりのブロックされたデータベース内のトランザクションの平均数。
//
resource "newrelic_nrql_alert_condition" "rds_blocked_transactions" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.rds_blocked_transactions_alerts)
  name                         = var.rds_blocked_transactions_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.rds.BlockedTransactions) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.rds.DBClusterIdentifier, aws.rds.DBInstanceIdentifier"
  }
  critical {
    operator              = "above"
    threshold             = 10
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：Deadlocks (Aurora)
// 内容：1 秒あたりのデータベース内のデッドロックの平均回数。
//
resource "newrelic_nrql_alert_condition" "rds_deadlocks" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.rds_deadlocks_alerts)
  name                         = var.rds_deadlocks_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.rds.Deadlocks) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.rds.DBClusterIdentifier, aws.rds.DBInstanceIdentifier"
  }
  critical {
    operator              = "above"
    threshold             = 10
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：FreeStorageSpace (RDS)
// 内容：使用可能なストレージ領域の容量。
//
resource "newrelic_nrql_alert_condition" "rds_free_storage_space" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.rds_free_storage_space_alerts)
  name                         = var.rds_free_storage_space_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.rds.FreeStorageSpace) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.rds.DBInstanceIdentifier"
  }
  critical {
    operator              = "below"
    threshold             = 10000000000
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：SwapUsage (RDS)
// 内容：DB インスタンスで使用するスワップ領域の量。
//
resource "newrelic_nrql_alert_condition" "rds_swap_usage" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.rds_swap_usage_alerts)
  name                         = var.rds_swap_usage_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.rds.SwapUsage) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.rds.DBInstanceIdentifier"
  }
  critical {
    operator              = "above"
    threshold             = 10
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}
