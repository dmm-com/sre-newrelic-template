resource "newrelic_nrql_alert_condition" "cpu" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ec2_cpu_alerts)
  name                         = var.ec2_cpu_alerts[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(aws.ec2.CPUUtilization) FROM Metric WHERE collector.name ='cloudwatch-metric-streams' AND aws.accountId IN (${var.aws_account_id}) AND tags.${var.ec2_cpu_alerts[count.index].tag_key} = '${var.ec2_cpu_alerts[count.index].tag_value}' FACET aws.ec2.InstanceId"
    evaluation_offset = 3
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "alive" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ec2_alive_alerts)
  name                         = var.ec2_alive_alerts[count.index].name
  violation_time_limit_seconds = 3600
  expiration_duration          = 300
  open_violation_on_expiration = true

  nrql {
    query             = "SELECT average(aws.ec2.StatusCheckFailed) FROM Metric WHERE aws.accountId IN (${var.aws_account_id}) AND tags.${var.ec2_alive_alerts[count.index].tag_key} = '${var.ec2_alive_alerts[count.index].tag_value}' FACET aws.ec2.InstanceId"
    evaluation_offset = 3
  }
  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "cpu_iowait" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ec2_cpuiowait_alerts)
  name                         = var.ec2_cpuiowait_alerts[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(cpuIOWaitPercent) FROM SystemSample WHERE aws.accountId IN (${var.aws_account_id}) AND tags.${var.ec2_cpuiowait_alerts[count.index].tag_key} = '${var.ec2_cpuiowait_alerts[count.index].tag_value}' FACET aws.ec2.InstanceId"
    evaluation_offset = 3
  }
  critical {
    operator              = "above"
    threshold             = 20
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "disk" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ec2_disk_alerts)
  name                         = var.ec2_disk_alerts[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(totalUtilizationPercent) FROM StorageSample WHERE aws.accountId IN (${var.aws_account_id}) AND tags.${var.ec2_disk_alerts[count.index].tag_key} = '${var.ec2_disk_alerts[count.index].tag_value}' FACET aws.ec2.InstanceId"
    evaluation_offset = 3
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
  warning {
    operator              = "above"
    threshold             = 80
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "load_average" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ec2_load_average_alerts)
  name                         = var.ec2_load_average_alerts[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(loadAverageFiveMinute) FROM SystemSample WHERE aws.accountId IN (${var.aws_account_id}) AND tags.${var.ec2_load_average_alerts[count.index].tag_key} = '${var.ec2_load_average_alerts[count.index].tag_value}' FACET aws.ec2.instanceId"
    evaluation_offset = 3
  }
  critical {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "timesync" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ec2_timesync_alerts)
  name                         = var.ec2_timesync_alerts[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT abs(latest(timestamp-flex.time.endMs)) AS timeshift FROM flexStatusSample WHERE aws.accountId IN (${var.aws_account_id}) AND tags.${var.ec2_timesync_alerts[count.index].tag_key} = '${var.ec2_timesync_alerts[count.index].tag_value}' FACET aws.ec2.instanceId"
    evaluation_offset = 3
  }
  critical {
    operator              = "above"
    threshold             = 10000 // 10sec
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "memory" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ec2_memory_alerts)
  name                         = var.ec2_memory_alerts[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    query             = "SELECT average(memoryUsedPercent) FROM SystemSample WHERE aws.accountId IN (${var.aws_account_id}) AND tags.${var.ec2_memory_alerts[count.index].tag_key} = '${var.ec2_memory_alerts[count.index].tag_value}' FACET aws.ec2.instanceId"
    evaluation_offset = 3
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "network" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ec2_network_alerts)
  name                         = var.ec2_network_alerts[count.index].name
  violation_time_limit_seconds = 3600

  nrql {
    // 帯域上限は直接取れないので、変数として入力している (出力単位を % にするため計算を行っている)
    query             = "SELECT (average(aws.ec2.NetworkIn)+average(aws.ec2.NetworkOut)) * 8e-6 / (${var.ec2_network_alerts[count.index].metrics_interval_minutes} * 60) / ${var.ec2_network_alerts[count.index].max_limit_bandwidth_mbps} * 100 FROM Metric WHERE aws.accountId IN (${var.aws_account_id}) AND tags.${var.ec2_network_alerts[count.index].tag_key} = '${var.ec2_network_alerts[count.index].tag_value}' FACET aws.ec2.instanceId"
    evaluation_offset = 3
  }
  critical {
    operator              = "above"
    threshold             = 90 // %
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}
