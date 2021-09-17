// --------------------
// Expect Aurora
// --------------------
resource "newrelic_nrql_alert_condition" "rds_alive" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  count                        = length(var.rds_alive_alerts)
  name                         = var.rds_alive_alerts[count.index].name
  violation_time_limit_seconds = 3600
  expiration_duration          = 300
  open_violation_on_expiration = true

  nrql {
    query             = "SELECT average(aws.rds.NetworkThroughput) FROM Metric WHERE aws.accountId IN (${var.aws_account_id}) AND tags.${var.rds_alive_alerts[count.index].tag_key} = '${var.rds_alive_alerts[count.index].tag_value}' FACET entityName"
    evaluation_offset = 3
  }
  critical {
    operator           = "equals"
    threshold          = 0
    threshold_duration = 60
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "rds_replica_lag" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  count                        = length(var.rds_replica_lag_alerts)
  name                         = var.rds_replica_lag_alerts[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(aws.rds.ReplicaLag) FROM Metric WHERE aws.accountId IN (${var.aws_account_id}) AND tags.${var.rds_replica_lag_alerts[count.index].tag_key} = '${var.rds_replica_lag_alerts[count.index].tag_value}' FACET aws.rds.DBInstanceIdentifier"
    evaluation_offset = 3
  }
  critical {
    operator           = "above"
    threshold          = 1
    threshold_duration = 60
    threshold_occurrences = "ALL"
  }
}


// --------------------
// Aurora
// --------------------
resource "newrelic_nrql_alert_condition" "rds_aurora_alive" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  count                        = length(var.rds_aurora_alive_alerts)
  name                         = var.rds_aurora_alive_alerts[count.index].name
  violation_time_limit_seconds = 3600
  expiration_duration          = 300
  open_violation_on_expiration = true

  nrql {
    query             = "SELECT count(aws.rds.status) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${var.aws_account_id}) AND aws.rds.status IN ('stopping','stopped') AND tags.${var.rds_aurora_alive_alerts[count.index].tag_key} = '${var.rds_aurora_alive_alerts[count.index].tag_value}' FACET entityName"
    evaluation_offset = 3
  }
  critical {
    operator           = "above"
    threshold          = 0
    threshold_duration = 60
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "rds_aurora_replica_lag" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  count                        = length(var.rds_aurora_replica_lag_alerts)
  name                         = var.rds_aurora_replica_lag_alerts[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(aws.rds.AuroraReplicaLag) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${var.aws_account_id}) AND tags.${var.rds_aurora_replica_lag_alerts[count.index].tag_key} = '${var.rds_aurora_replica_lag_alerts[count.index].tag_value}' FACET entityName"
    evaluation_offset = 3
  }
  critical {
    operator           = "above"
    threshold          = 1000 // 1sec
    threshold_duration = 60
    threshold_occurrences = "ALL"
  }
}
