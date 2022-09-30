data "aws_caller_identity" "self" {}

// 監視メトリクス：CPUUtilization
// 内容：割り当てられた EC2 コンピュートユニットのうち、現在インスタンス上で使用されているものの比率。
//
resource "newrelic_nrql_alert_condition" "ec2_cpu_utilization" {
  policy_id = var.policy_id
  name      = "[EC2] CPU使用率監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(aws.ec2.CPUUtilization) FROM Metric WHERE collector.name ='cloudwatch-metric-streams' AND aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.ec2.InstanceId, tags.Name"
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}

// 監視メトリクス：StatusCheckFailed
// 内容：インスタンスが過去 1 分間にインスタンスのステータスチェックとシステムステータスチェックの両方に合格したかどうかを報告します。
//
resource "newrelic_nrql_alert_condition" "ec2_status_check_failed" {
  policy_id = var.policy_id
  name      = "[EC2] ステータス監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(aws.ec2.StatusCheckFailed) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.ec2.InstanceId, tags.Name"
  }
  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  expiration_duration          = 300
  open_violation_on_expiration = true

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}

// 監視イベント：cpuIOWaitPercent
// 内容：現在の CPU 使用率の部分は、I/O 待機時間の使用状況のみで構成されます。
//
resource "newrelic_nrql_alert_condition" "ec2_cpu_iowait_percent" {
  policy_id = var.policy_id
  name      = "[EC2] CPU I/O Wait監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(cpuIOWaitPercent) FROM SystemSample WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET entityKey, tags.Name"
  }
  critical {
    operator              = "above"
    threshold             = 20
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}

// 監視イベント：totalUtilizationPercent
// 内容：読み取りまたは書き込みディスク I/O 操作の待機に費やされた時間の割合。
//
resource "newrelic_nrql_alert_condition" "ec2_total_utilization_percent" {
  policy_id = var.policy_id
  name      = "[EC2] ディスクI/O Wait監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(totalUtilizationPercent) FROM StorageSample WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET entityKey, tags.Name"
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

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}

// 監視イベント：loadAverageFiveMinute
// 内容：過去 5 分間に、CPU 時間を待機し、準備完了しているシステム・プロセス、スレッド、またはタスクの平均数。
//
resource "newrelic_nrql_alert_condition" "ec2_load_average_five_minute" {
  policy_id = var.policy_id
  name      = "[EC2] ロードアベレージ監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(loadAverageFiveMinute) FROM SystemSample WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET entityKey, tags.Name"
  }
  critical {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}

// 監視イベント：timeshift
// 内容：時刻同期のずれ。
//
resource "newrelic_nrql_alert_condition" "ec2_timesync" {
  policy_id = var.policy_id
  name      = "[EC2] 時刻同期監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT abs(latest(timestamp-flex.time.endMs)) AS timeshift FROM flexStatusSample WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET entityKey, tags.Name"
  }
  critical {
    operator              = "above"
    threshold             = 10000 // 10sec
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}

// 監視イベント：memoryUsedPercent
// 内容：メモリ使用率。
//
resource "newrelic_nrql_alert_condition" "ec2_memory_used_percent" {
  policy_id = var.policy_id
  name      = "[EC2] メモリ使用率監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(memoryUsedPercent) FROM SystemSample WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET entityKey, tags.Name"
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}

// 監視イベント：diskUsedPercent
// 内容：累積ディスク使用率の割合。
//
resource "newrelic_nrql_alert_condition" "ec2_disk_used_percent" {
  policy_id = var.policy_id
  name      = "[EC2] ディスク使用率監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(diskUsedPercent) FROM StorageSample WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET entityKey, tags.Name"
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}

// 監視イベント：inodesUsedPercent
// 内容：i ノード使用率の割合。
//
resource "newrelic_nrql_alert_condition" "ec2_inodes_used_percent" {
  policy_id = var.policy_id
  name      = "[EC2] iノード使用率監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(inodesUsedPercent) FROM StorageSample WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET entityKey, tags.Name"
  }
  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}
