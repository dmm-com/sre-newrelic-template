// --------------------
// Expect Aurora
// --------------------
resource "newrelic_nrql_alert_condition" "rds_alive" {
  policy_id = newrelic_alert_policy.policy.id

  count                        = length(var.rds_alive_alert_names)
  name                         = var.rds_alive_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(aws.rds.NetworkThroughput) FROM Metric FACET entityName WHERE aws.accountId IN (${var.aws_account_id}) SINCE 5 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "equals"
    threshold = 0
  }
}

resource "newrelic_nrql_alert_condition" "rds_replica_lag" {
  policy_id = newrelic_alert_policy.policy.id

  count                        = length(var.rds_replica_lag_alert_names)
  name                         = var.rds_replica_lag_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(aws.rds.ReplicaLag) FROM Metric FACET aws.rds.DBInstanceIdentifier WHERE aws.accountId IN (${var.aws_account_id}) SINCE 5 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 1
  }
}


// --------------------
// Aurora
// --------------------
resource "newrelic_nrql_alert_condition" "rds_aurora_alive" {
  policy_id = newrelic_alert_policy.policy.id

  count                        = length(var.rds_aurora_alive_alert_names)
  name                         = var.rds_aurora_alive_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT count(aws.rds.status) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${var.aws_account_id}) AND aws.rds.status != 'available' FACET entityName SINCE 5 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 1
  }
}

resource "newrelic_nrql_alert_condition" "rds_aurora_replica_lag" {
  policy_id = newrelic_alert_policy.policy.id

  count                        = length(var.rds_aurora_replica_lag_alert_names)
  name                         = var.rds_aurora_replica_lag_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(aws.rds.AuroraReplicaLag) FROM Metric WHERE collector.name = 'cloudwatch-metric-streams' AND aws.accountId IN (${var.aws_account_id}) FACET entityName SINCE 5 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 1000
  }
}
