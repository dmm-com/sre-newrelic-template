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

  count = length(var.cpu_alert_names)
  name  = var.cpu_alert_names[count.index]

  // TODO: ec2のタグ名を入れていないのであとで入れる
  nrql {
    query = "SELECT average(aws.ec2.CPUUtilization) FROM Metric WHERE collector.name ='cloudwatch-metric-streams' FACET entity.name SINCE 30 minutes ago"
  }
  critical {
    operator  = "above"
    threshold = 90
  }
}

resource "newrelic_nrql_alert_condition" "alive" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.alive_alert_names)
  name  = var.alive_alert_names[count.index]

  aws_account_ids = join(",", var.aws_account.ids)
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

  count = length(var.cpuiowait_alert_names)
  name  = var.cpuiowait_alert_names[count.index]

  aws_account_ids = join(",", var.aws_account.ids)
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

  count = length(var.disk_alert_names)
  name  = var.disk_alert_names[count.index]

  aws_account_ids = join(",", var.aws_account.ids)
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

  count = length(var.load_average_alert_names)
  name  = var.load_average_alert_names[count.index]

  aws_account_ids = join(",", var.aws_account.ids)
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

  count = length(var.timesync_alert_names)
  name  = var.timesync_alert_names[count.index]

  aws_account_ids = join(",", var.aws_account.ids)
  // TODO: chrony + 時刻同期を使って行う
  nrql {
    query = "SELECT average(loadAverageFiveMinutes) FROM SystemSample FACET entityName WHERE aws.accountId IN (${aws_account_ids}) SINCE 1 minutes ago"
  }
  critical {
    operator  = "above"
    threshold = 10
  }
}

resource "newrelic_nrql_alert_condition" "memory" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.memory_alert_names)
  name  = var.memory_alert_names[count.index]

  aws_account_ids = join(",", var.aws_account.ids)

  nrql {
    query = "SELECT average(memoryUsedPercent) FROM SystemSample FACET entityName WHERE aws.accountId IN (${aws_account_ids}) SINCE 1 minutes ago"
  }
  critical {
    operator  = "above"
    threshold = 90
  }
}

// ネットワークは上限が決められないため一旦保留
// resource "newrelic_nrql_alert_condition" "network" {
//   policy_id = newrelic_alert_policy.default.id
// 
//   count = length(var.newrelic_infra_agent_alert_network)
//   name  = var.newrelic_infra_agent_alert_network.alert_name[count.index]
// 
//   aws_account_ids = join(",", var.aws_account.ids)
// 
//   nrql {
//     query = "SELECT average(memoryUsedPercent) FROM SystemSample FACET entityName WHERE aws.accountId IN (${aws_account_ids}) SINCE 1 minutes ago"
//   }
//   critical {
//     operator  = "above"
//     threshold = 90
//   }
// }

resource "newrelic_nrql_alert_condition" "rds_alive" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.rds_alive_alert_names)
  name  = var.rds_alive_alert_names[count.index]

  aws_account_ids = join(",", var.aws_account.ids)

  nrql {
    // problem: https://git.dmm.com/sre-team/newrelic-alert/issues/11
    query = "SELECT average(aws.rds.NetworkThroughput) FROM Metrics FACET entityName WHERE aws.accountId IN (${aws_account_ids}) SINCE 3 minutes ago"
  }
  critical {
    operator  = "equal"
    threshold = 0
  }
}
