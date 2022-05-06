// 監視メトリクス：CPUUtilization
// 内容：割り当てられた EC2 コンピュートユニットのうち、現在インスタンス上で使用されているものの比率。
//
resource "newrelic_nrql_alert_condition" "ec2_cpu_utilization" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ec2_cpu_utilization_alerts)
  name                         = var.ec2_cpu_utilization_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.ec2.CPUUtilization) FROM Metric WHERE collector.name ='cloudwatch-metric-streams' AND aws.accountId IN (${data.aws_caller_identity.self.account_id}) AND tags.${var.ec2_cpu_utilization_alerts[count.index].tag_key} = '${var.ec2_cpu_utilization_alerts[count.index].tag_value}' FACET aws.ec2.InstanceId, tags.Name"
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：StatusCheckFailed
// 内容：インスタンスが過去 1 分間にインスタンスのステータスチェックとシステムステータスチェックの両方に合格したかどうかを報告します。
//
resource "newrelic_nrql_alert_condition" "ec2_status_check_failed" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ec2_status_check_failed_alerts)
  name                         = var.ec2_status_check_failed_alerts[count.index].name
  violation_time_limit_seconds = 3600
  expiration_duration          = 300
  open_violation_on_expiration = true

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(aws.ec2.StatusCheckFailed) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) AND tags.${var.ec2_status_check_failed_alerts[count.index].tag_key} = '${var.ec2_status_check_failed_alerts[count.index].tag_value}' FACET aws.ec2.InstanceId, tags.Name"
  }
  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視イベント：cpuIOWaitPercent
// 内容：現在の CPU 使用率の部分は、I/O 待機時間の使用状況のみで構成されます。
//
resource "newrelic_nrql_alert_condition" "ec2_cpu_iowait_percent" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ec2_cpu_iowait_percent_alerts)
  name                         = var.ec2_cpu_iowait_percent_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(cpuIOWaitPercent) FROM SystemSample WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) AND tags.${var.ec2_cpu_iowait_percent_alerts[count.index].tag_key} = '${var.ec2_cpu_iowait_percent_alerts[count.index].tag_value}' FACET entityKey, tags.Name"
  }
  critical {
    operator              = "above"
    threshold             = 20
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視イベント：totalUtilizationPercent
// 内容：読み取りまたは書き込みディスク I/O 操作の待機に費やされた時間の割合。
//
resource "newrelic_nrql_alert_condition" "ec2_total_utilization_percent" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ec2_total_utilization_percent_alerts)
  name                         = var.ec2_total_utilization_percent_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(totalUtilizationPercent) FROM StorageSample WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) AND tags.${var.ec2_total_utilization_percent_alerts[count.index].tag_key} = '${var.ec2_total_utilization_percent_alerts[count.index].tag_value}' FACET entityKey, tags.Name"
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

// 監視イベント：loadAverageFiveMinute
// 内容：過去 5 分間に、CPU 時間を待機し、準備完了しているシステム・プロセス、スレッド、またはタスクの平均数。
//
resource "newrelic_nrql_alert_condition" "ec2_load_average_five_minute" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ec2_load_average_five_minute_alerts)
  name                         = var.ec2_load_average_five_minute_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(loadAverageFiveMinute) FROM SystemSample WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) AND tags.${var.ec2_load_average_five_minute_alerts[count.index].tag_key} = '${var.ec2_load_average_five_minute_alerts[count.index].tag_value}' FACET entityKey, tags.Name"
  }
  critical {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視イベント：
// 内容：
//
resource "newrelic_nrql_alert_condition" "ec2_timesync" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ec2_timesync_alerts)
  name                         = var.ec2_timesync_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT abs(latest(timestamp-flex.time.endMs)) AS timeshift FROM flexStatusSample WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) AND tags.${var.ec2_timesync_alerts[count.index].tag_key} = '${var.ec2_timesync_alerts[count.index].tag_value}' FACET entityKey, tags.Name"
  }
  critical {
    operator              = "above"
    threshold             = 10000 // 10sec
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視イベント：memoryUsedPercent
// 内容：メモリ使用率。
//
resource "newrelic_nrql_alert_condition" "ec2_memory_used_percent" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ec2_memory_used_percent_alerts)
  name                         = var.ec2_memory_used_percent_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(memoryUsedPercent) FROM SystemSample WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) AND tags.${var.ec2_memory_used_percent_alerts[count.index].tag_key} = '${var.ec2_memory_used_percent_alerts[count.index].tag_value}' FACET entityKey, tags.Name"
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視メトリクス：NetworkIn, NetworkOut
// 内容：帯域使用率を算出。
//
resource "newrelic_nrql_alert_condition" "ec2_network_bandwidth_used_percent" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ec2_network_bandwidth_used_percent_alerts)
  name                         = var.ec2_network_bandwidth_used_percent_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    // 帯域上限は直接取れないので、変数として入力している (出力単位を % にするため計算を行っている)
    query             = "SELECT (average(aws.ec2.NetworkIn)+average(aws.ec2.NetworkOut)) * 8e-6 / (${var.ec2_network_bandwidth_used_percent_alerts[count.index].metrics_interval_minutes} * 60) / ${var.ec2_network_bandwidth_used_percent_alerts[count.index].max_limit_bandwidth_mbps} * 100 FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) AND tags.${var.ec2_network_bandwidth_used_percent_alerts[count.index].tag_key} = '${var.ec2_network_bandwidth_used_percent_alerts[count.index].tag_value}' FACET aws.ec2.instanceId, tags.Name"
  }
  critical {
    operator              = "above"
    threshold             = 90 // %
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視イベント：diskUsedPercent
// 内容：累積ディスク使用率の割合。
//
resource "newrelic_nrql_alert_condition" "ec2_disk_used_percent" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ec2_disk_used_percent_alerts)
  name                         = var.ec2_disk_used_percent_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(diskUsedPercent) FROM StorageSample WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) AND tags.${var.ec2_disk_used_percent_alerts[count.index].tag_key} = '${var.ec2_disk_used_percent_alerts[count.index].tag_value}' FACET entityKey, tags.Name"
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 監視イベント：inodesUsedPercent
// 内容：i ノード使用率の割合。
//
resource "newrelic_nrql_alert_condition" "ec2_inodes_used_percent" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.ec2_inodes_used_percent_alerts)
  name                         = var.ec2_inodes_used_percent_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(inodesUsedPercent) FROM StorageSample WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) AND tags.${var.ec2_inodes_used_percent_alerts[count.index].tag_key} = '${var.ec2_inodes_used_percent_alerts[count.index].tag_value}' FACET entityKey, tags.Name"
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}
