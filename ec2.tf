resource "newrelic_nrql_alert_condition" "cpu" {
  policy_id = newrelic_alert_policy.policy.id

  count                        = length(var.cpu_alerts)
  name                         = var.cpu_alerts[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(aws.ec2.CPUUtilization) FROM Metric WHERE collector.name ='cloudwatch-metric-streams' AND aws.accountId IN (${var.aws_account_id}) AND tags.${var.cpu_alerts[count.index].ec2_tag_key} = '${var.cpu_alerts[count.index].ec2_tag_value}' FACET entity.name SINCE 30 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 90
  }
}

resource "newrelic_nrql_alert_condition" "alive" {
  policy_id = newrelic_alert_policy.policy.id

  count                        = length(var.alive_alert_names)
  name                         = var.alive_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT count(aws.ec2.state) FROM Metric WHERE collector.name ='cloudwatch-metric-streams' AND aws.accountId IN (${var.aws_account_id}) AND aws.ec2.state != 'running' FACET aws.ec2.InstanceId SINCE 5 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 1
  }
}

resource "newrelic_nrql_alert_condition" "cpu_iowait" {
  policy_id = newrelic_alert_policy.policy.id

  count                        = length(var.cpuiowait_alert_names)
  name                         = var.cpuiowait_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(cpuIOWaitPercent) FROM SystemSample FACET entityName WHERE aws.accountId IN (${var.aws_account_id}) SINCE 5 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 20
  }
}

resource "newrelic_nrql_alert_condition" "disk" {
  policy_id = newrelic_alert_policy.policy.id

  count                        = length(var.disk_alert_names)
  name                         = var.disk_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(totalUtilizationPercent) FROM StorageSample FACET entityName WHERE aws.accountId IN (${var.aws_account_id}) SINCE 5 minutes ago"
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
  policy_id = newrelic_alert_policy.policy.id

  count                        = length(var.load_average_alert_names)
  name                         = var.load_average_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(loadAverageFiveMinutes) FROM SystemSample FACET entityName WHERE aws.accountId IN (${var.aws_account_id}) SINCE 1 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 5
  }
}

resource "newrelic_nrql_alert_condition" "timesync" {
  policy_id = newrelic_alert_policy.policy.id

  count                        = length(var.timesync_alerts)
  name                         = var.timesync_alerts[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    // 出力単位はミリ秒
    query             = "SELECT abs(latest(timestamp-flex.time.endMs)) AS timeshift FROM flexStatusSample FACET aws.ec2.InstanceId WHERE aws.accountId IN (${var.aws_account_id}) SINCE 5 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 10000
  }
}

resource "newrelic_nrql_alert_condition" "memory" {
  policy_id = newrelic_alert_policy.policy.id

  count                        = length(var.memory_alert_names)
  name                         = var.memory_alert_names[count.index]
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(memoryUsedPercent) FROM SystemSample FACET entityName WHERE aws.accountId IN (${var.aws_account_id}) SINCE 5 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 90
  }
}

resource "newrelic_nrql_alert_condition" "network" {
  policy_id = newrelic_alert_policy.policy.id

  count                        = length(var.alert_network)
  name                         = var.alert_network[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    // 帯域上限はは直接取れないので、変数として入力している (出力単位を % にするため計算を行っている)
    query             = "SELECT (average(aws.ec2.NetworkIn)+average(aws.ec2.NetworkOut)) * 8e-6 / (${var.alert_network[count.index].metrics_interval_minutes} * 60) / ${var.alert_network[count.index].max_limit_bandwidth_mbps} * 100 FROM Metric FACET entityName WHERE aws.accountId IN (${var.aws_account_id}) SINCE 5 minutes ago"
    evaluation_offset = 3
  }
  critical {
    operator  = "above"
    threshold = 90
  }
}
