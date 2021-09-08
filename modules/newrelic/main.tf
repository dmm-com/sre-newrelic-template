resource "newrelic_synthetics_monitor" "ping" {
  count = length(var.newrelic_synthetics_pings)

  type                      = "SIMPLE"
  name                      = var.newrelic_synthetics_ping.name[count.index]
  frequency                 = var.newrelic_synthetics_ping.frequency[count.index]
  uri                       = var.newrelic_synthetics_ping.uri[count.index]
  validation_string         = var.newrelic_synthetics_ping.validation_string[count.index]
  verify_ssl                = var.newrelic_synthetics_ping.verify_ssl[count.index]
  bypass_head_request       = var.newrelic_synthetics_ping.bypass_head_request[count.index]
  treat_redirect_as_failure = var.newrelic_synthetics_ping.treat_redirect_as_failure[count.index]
}

resource "newrelic_synthetics_monitor" "syn_browser" {
  count = length(var.newrelic_synthetics_browser)

  type                = "BROWSER"
  name                = var.newrelic_synthetics_browser.name[count.index]
  frequency           = var.newrelic_synthetics_browser.frequency[count.index]
  uri                 = var.newrelic_synthetics_browser.uri[count.index]
  validation_string   = var.newrelic_synthetics_browser.validation_string[count.index]
  verify_ssl          = var.newrelic_synthetics_browser.verify_ssl[count.index]
  bypass_head_request = var.newrelic_synthetics_browser.bypass_head_request[count.index]
}

// todo: policyをハードコードしてる部分をもう少し考える
resource "newrelic_alert_policy" "default" {
  name = "default"
}

resource "newrelic_nrql_alert_condition" "cpu" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.newrelic_alert_cpu)
  name  = var.newrelic_alert_cpu.name[count.index]

  // TODO: ec2のタグ名を入れていないのであとで入れる
  nrql {
    query = "SELECT average(aws.ec2.CPUUtilization) FROM Metric WHERE collector.name ='cloudwatch-metric-streams' FACET entity.name SINCE 30 minutes ago"
  }
  critical {
    operator  = "above"
    threshold = 90
  }
}

// 死活監視を拡張モニタリングに回す
resource "newrelic_nrql_alert_condition" "alive" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.newrelic_infra_agent_alert_alive)
  name  = var.newrelic_infra_agent_alert_alive.alert_name[count.index]

  aws_account_ids = join(",", var.newrelic_infra_agent_alert_alive.aws_account_id[count.index])
  nrql {
    query = "SELECT average(receiveBytesPerSecond) FROM NetworkSample FACET entityAndInterface WHERE aws.accountId IN (${aws_account_ids}) SINCE 1 minutes ago"
  }
  critical {
    operator  = "equal"
    threshold = 0
  }
}

resource "newrelic_nrql_alert_condition" "cpu_iowait" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.newrelic_infra_agent_alert_cpu_iowait)
  name  = var.newrelic_infra_agent_alert_cpu_iowait.alert_name[count.index]

  aws_account_ids = join(",", var.newrelic_infra_agent_alert_cpu_iowait.aws_account_id[count.index])
  nrql {
    query = "SELECT average(cpuIOWaitPercent) FROM SystemSample FACET entityName WHERE aws.accountId IN (${aws_account_ids}) SINCE 5 minutes ago"
  }
  critical {
    operator  = "above"
    threshold = 20
  }
}

resource "newrelic_nrql_alert_condition" "disk" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.newrelic_infra_agent_alert_disk)
  name  = var.newrelic_infra_agent_alert_disk.alert_name[count.index]

  aws_account_ids = join(",", var.newrelic_infra_agent_alert_disk.aws_account_id[count.index])
  nrql {
    query = "SELECT average(totalUtilizationPercent) FROM StorageSample FACET entityName WHERE aws.accountId IN (${aws_account_ids}) SINCE 1 minutes ago"
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

  count = length(var.newrelic_infra_agent_alert_load_average)
  name  = var.newrelic_infra_agent_alert_load_average.alert_name[count.index]

  aws_account_ids = join(",", var.newrelic_infra_agent_alert_load_average.aws_account_id[count.index])
  nrql {
    query = "SELECT average(loadAverageFiveMinutes) FROM SystemSample FACET entityName WHERE aws.accountId IN (${aws_account_ids}) SINCE 1 minutes ago"
  }
  critical {
    operator  = "above"
    threshold = 5
  }
}

resource "newrelic_nrql_alert_condition" "timesync" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.newrelic_infra_agent_alert_timesync)
  name  = var.newrelic_infra_agent_alert_timesync.alert_name[count.index]

  aws_account_ids = join(",", var.newrelic_infra_agent_alert_timesync.aws_account_id[count.index])
  // TODO: 時計サーバの指定が必要な可能性高 別の変数を用意する
  nrql {
    query = "SELECT average(loadAverageFiveMinutes) FROM SystemSample FACET entityName WHERE aws.accountId IN (${aws_account_ids}) SINCE 1 minutes ago"
  }
  critical {
    operator  = "above"
    threshold = 10
  }
}
