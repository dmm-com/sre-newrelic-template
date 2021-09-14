terraform {
  required_version = "1.0.6"

  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 2.25.0"
    }
  }
}

provider "newrelic" {
  region     = "US"
  account_id = var.nr_account_id
  api_key    = var.nr_api_key
}

resource "newrelic_alert_policy" "default" {
  name = "default"
}

resource "newrelic_alert_channel" "channel" {
  count = length(var.alert_slack_channel)

  type = "slack"
  name = var.alert_slack_channel[count.index].name

  config {
    url     = var.alert_slack_channel[count.index].url
    channel = var.alert_slack_channel[count.index].channel
  }
}

resource "newrelic_nrql_alert_condition" "cpu" {
  policy_id = newrelic_alert_policy.default.id

  count                        = length(var.cpu_alerts)
  name                         = var.cpu_alerts[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(aws.ec2.CPUUtilization) FROM Metric WHERE collector.name ='cloudwatch-metric-streams' AND tags.${var.cpu_alerts[count.index].ec2_tag_key} = '${var.cpu_alerts[count.index].ec2_tag_value}' FACET entity.name SINCE 30 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 90
  }
}

resource "newrelic_nrql_alert_condition" "alive" {
  policy_id = newrelic_alert_policy.default.id

  count                        = length(var.alive_alert_names)
  name                         = var.alive_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT count(*) FROM Metric WHERE collector.name ='cloudwatch-metric-streams' AND aws.accountId IN (${join(",", var.aws_account_ids)}) AND aws.ec2.state IS NOT NULL AND aws.ec2.state != 'running' FACET aws.ec2.InstanceId SINCE 5 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 1
  }
}

resource "newrelic_nrql_alert_condition" "cpu_iowait" {
  policy_id = newrelic_alert_policy.default.id

  count                        = length(var.cpuiowait_alert_names)
  name                         = var.cpuiowait_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(cpuIOWaitPercent) FROM SystemSample FACET entityName WHERE aws.accountId IN (${join(",", var.aws_account_ids)}) SINCE 5 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 20
  }
}

resource "newrelic_nrql_alert_condition" "disk" {
  policy_id = newrelic_alert_policy.default.id

  count                        = length(var.disk_alert_names)
  name                         = var.disk_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(totalUtilizationPercent) FROM StorageSample FACET entityName WHERE aws.accountId IN (${join(",", var.aws_account_ids)}) SINCE 1 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 90
  }
  warning {
    operator  = "above"
    threshold = 80
  }
}


resource "newrelic_nrql_alert_condition" "load_average" {
  policy_id = newrelic_alert_policy.default.id

  count                        = length(var.load_average_alert_names)
  name                         = var.load_average_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(loadAverageFiveMinutes) FROM SystemSample FACET entityName WHERE aws.accountId IN (${join(",", var.aws_account_ids)}) SINCE 1 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 5
  }
}

resource "newrelic_nrql_alert_condition" "timesync" {
  policy_id = newrelic_alert_policy.default.id

  count                        = length(var.timesync_alert_names)
  name                         = var.timesync_alert_names[count.index]
  violation_time_limit_seconds = 3600

  // TODO: 時刻管理サーバのunixtimestamp - 監視対象サーバへのunixtimestamp > 10ならアラート
  nrql {
    query             = "SELECT average(loadAverageFiveMinutes) FROM SystemSample FACET entityName WHERE aws.accountId IN (${join(",", var.aws_account_ids)}) SINCE 1 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 10
  }
}

resource "newrelic_nrql_alert_condition" "memory" {
  policy_id = newrelic_alert_policy.default.id

  count                        = length(var.memory_alert_names)
  name                         = var.memory_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(memoryUsedPercent) FROM SystemSample FACET entityName WHERE aws.accountId IN (${join(",", var.aws_account_ids)}) SINCE 1 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 90
  }
}

resource "newrelic_nrql_alert_condition" "network" {
  policy_id = newrelic_alert_policy.default.id

  count                        = length(var.alert_network)
  name                         = var.alert_network[count.index].name
  violation_time_limit_seconds = 3600


  // TODO: networkは直接取れないので、
  nrql {
    query             = "SELECT average(memoryUsedPercent) FROM SystemSample FACET entityName WHERE aws.accountId IN (${join(",", var.aws_account_ids)}) SINCE 1 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 90
  }
}

resource "newrelic_nrql_alert_condition" "rds_alive" {
  policy_id = newrelic_alert_policy.default.id

  count                        = length(var.rds_alive_alert_names)
  name                         = var.rds_alive_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(aws.rds.NetworkThroughput) FROM Metrics FACET entityName WHERE aws.accountId IN (${join(",", var.aws_account_ids)}) SINCE 5 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "equals"
    threshold = 0
  }
}

resource "newrelic_nrql_alert_condition" "rds_replica_lag" {
  policy_id = newrelic_alert_policy.default.id

  count                        = length(var.rds_replica_lag_alert_names)
  name                         = var.rds_replica_lag_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    // TODO: レプリカラグがレプリカがないと取れなそうなので、NRQLで試す
    query             = "SELECT average(aws.rds.ReplicaLag) FROM Metrics FACET entityName WHERE aws.accountId IN (${join(",", var.aws_account_ids)}) SINCE 3 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 1
  }
}


resource "newrelic_nrql_alert_condition" "rds_connection" {
  policy_id = newrelic_alert_policy.default.id

  count                        = length(var.rds_connection_alert_names)
  name                         = var.rds_connection_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    // TODO: FACETがentityNameだとClientConnectionが、rds.targetだとmaxconnectionが取れないので、どうやって分割するか
    query             = "SELECT average(aws.rds.ReplicaLag) FROM Metrics FACET entityName WHERE aws.accountId IN (${join(",", var.aws_account_ids)}) SINCE 3 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator = "above"
    // todo: 割合は未定、あとで入れる
    threshold = 99
  }
}
