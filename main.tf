resource "newrelic_synthetics_monitor" "ping" {
  count = length(local.newrelic_synthetics_pings)

  type                      = "SIMPLE"
  name                      = local.newrelic_synthetics_ping.name[count.index]
  frequency                 = local.newrelic_synthetics_ping.frequency[count.index]
  uri                       = local.newrelic_synthetics_ping.uri[count.index]
  validation_string         = local.newrelic_synthetics_ping.validation_string[count.index]
  verify_ssl                = local.newrelic_synthetics_ping.verify_ssl[count.index]
  bypass_head_request       = local.newrelic_synthetics_ping.bypass_head_request[count.index]
  treat_redirect_as_failure = local.newrelic_synthetics_ping.treat_redirect_as_failure[count.index]
}

resource "newrelic_synthetics_monitor" "syn_browser" {
  count = length(local.newrelic_synthetics_browser)

  type                = "BROWSER"
  name                = local.newrelic_synthetics_browser.name[count.index]
  frequency           = local.newrelic_synthetics_browser.frequency[count.index]
  uri                 = local.newrelic_synthetics_browser.uri[count.index]
  validation_string   = local.newrelic_synthetics_browser.validation_string[count.index]
  verify_ssl          = local.newrelic_synthetics_browser.verify_ssl[count.index]
  bypass_head_request = local.newrelic_synthetics_browser.bypass_head_request[count.index]
}

resource "newrelic_alert_policy" "default" {
  name = "default"
}

// 死活監視
resource "newrelic_infra_alert_condition" "alive" {
  policy_id = newrelic_alert_policy.default.id

  name        = "ec2 not running"
  description = "Critical alert when ec2 not running"
  type        = "infra_metric"
  event       = "SystemSample"
  comparison  = "equal"
  where       = "ec2Tag_Name IN (${join(",", [for v in var.tags : format("¥'%q¥'", s)])})"

  critical {
    duration = 1
  }
}

resource "newrelic_infra_alert_condition" "cpu" {
  policy_id = newrelic_alert_policy.default.id

  name        = "cpu monitor"
  description = "alert cpu usage more than 90%"
  type        = "infra_metric"
  event       = "SystemSample"
  select      = "cpuPercent"
  comparison  = "above"
  where       = "ec2Tag_Name IN (${join(",", [for v in var.tags : format("¥'%q¥'", s)])})"

  critical {
    duration      = 30
    value         = 90
    time_function = "all"
  }
}

resource "newrelic_infra_alert_condition" "cpu_iowait" {
  policy_id = newrelic_alert_policy.default.id

  name        = "cpu iowait monitor"
  description = "alert when high cpu iowait"
  type        = "infra_metric"
  event       = "SystemSample"
  select      = "cpuIOWaitPercent"
  comparison  = "above"
  where       = "ec2Tag_Name IN (${join(",", [for v in var.tags : format("¥'%q¥'", s)])})"

  critical {
    duration      = 5
    value         = 20
    time_function = "all"
  }
}
