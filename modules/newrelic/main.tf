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

// policyをハードコードしてる部分をもう少し考える
resource "newrelic_alert_policy" "default" {
  name = "default"
}

// 死活監視を一旦拡張モニタリングに回す
// resource "newrelic_nrql_alert_condition" "alive" {
//   count = length(var.newrelic_alert_alive)
// 
//   policy_id  = newrelic_alert_policy.default.id
//   name       = var.newrelic_alert_alive.name[count.index]
//   account_id = var.newrelic_alert_alive.aws_account_id[count.index]
// 
//   nrql {
//     query = "SELECT average() FROM Metric WHERE collector.name ='cloudwatch-metric-streams' FACET entity.name"
//   }
//   critical {
//     operator  = "above"
//     threshold = 90
//   }
// }

resource "newrelic_nrql_alert_condition" "cpu" {
  count = length(var.newrelic_alert_cpu)

  policy_id  = newrelic_alert_policy.default.id
  name       = var.newrelic_alert_cpu.name[count.index]
  account_id = var.newrelic_alert_cpu.aws_account_id[count.index]

  nrql {
    query = "SELECT average(aws.ec2.CPUUtilization) FROM Metric WHERE collector.name ='cloudwatch-metric-streams' FACET entity.name SINCE 30 minutes ago"
  }
  critical {
    operator  = "above"
    threshold = 90
  }
}
