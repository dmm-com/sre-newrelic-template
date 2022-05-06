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

resource "newrelic_nrql_alert_condition" "rds_aurora_alive" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.rds_aurora_alive_alerts)
  name                         = var.rds_aurora_alive_alerts[count.index].name
  violation_time_limit_seconds = 3600
  expiration_duration          = 300
  open_violation_on_expiration = true

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT count(aws.rds.status) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${data.aws_caller_identity.self.account_id}) AND aws.rds.status IN ('stopping','stopped') AND tags.${var.rds_aurora_alive_alerts[count.index].tag_key} = '${var.rds_aurora_alive_alerts[count.index].tag_value}' FACET entityName"
  }
  critical {
    operator           = "above"
    threshold          = 0
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
