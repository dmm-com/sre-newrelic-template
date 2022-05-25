// 内容：SyntheticsのPing監視
//
resource "newrelic_synthetics_monitor" "synthetics_ping" {
  count = length(var.newrelic_synthetics_ping)

  name      = var.newrelic_synthetics_ping[count.index].name
  type      = "SIMPLE"
  frequency = 1
  locations = ["AWS_AP_NORTHEAST_1", "AWS_US_WEST_1", "AWS_US_EAST_1"]
  status    = var.newrelic_synthetics_ping[count.index].status

  uri                       = var.newrelic_synthetics_ping[count.index].uri
  validation_string         = var.newrelic_synthetics_ping[count.index].validation_string
  verify_ssl                = var.newrelic_synthetics_ping[count.index].verify_ssl
  bypass_head_request       = var.newrelic_synthetics_ping[count.index].bypass_head_request
  treat_redirect_as_failure = var.newrelic_synthetics_ping[count.index].treat_redirect_as_failure
}

// 内容：SyntheticsのSimple Browser監視
//
resource "newrelic_synthetics_monitor" "synthetics_browser" {
  count = length(var.newrelic_synthetics_browser)

  name      = var.newrelic_synthetics_browser[count.index].name
  type      = "BROWSER"
  frequency = 1
  locations = ["AWS_AP_NORTHEAST_1", "AWS_US_WEST_1", "AWS_US_EAST_1"]
  status    = var.newrelic_synthetics_browser[count.index].status

  uri                 = var.newrelic_synthetics_browser[count.index].uri
  validation_string   = var.newrelic_synthetics_browser[count.index].validation_string
  verify_ssl          = var.newrelic_synthetics_browser[count.index].verify_ssl
  bypass_head_request = var.newrelic_synthetics_browser[count.index].bypass_head_request
}

// 内容：Synthetics Pingの内部設定情報取得
//
data "newrelic_synthetics_monitor" "synthetics_ping" {
  count = length(var.newrelic_synthetics_ping)

  name = var.newrelic_synthetics_ping[count.index].name

  depends_on = [
    newrelic_synthetics_monitor.synthetics_ping
  ]
}

// 監視メトリクス：SyntheticCheck duration
// 内容：この要求の合計時間 (ミリ秒単位)。
//
resource "newrelic_nrql_alert_condition" "synthetics_ping_alert" {
  count = length(var.newrelic_synthetics_ping)

  policy_id = newrelic_alert_policy.policy.id
  name      = "[Synthetics Ping] \"${var.newrelic_synthetics_ping[count.index].uri}\" レスポンスタイム監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(duration) FROM SyntheticCheck WHERE location = 'AWS_AP_NORTHEAST_1' AND monitorId = '${data.newrelic_synthetics_monitor.synthetics_ping[count.index].id}'"
  }
  critical {
    operator              = "above"
    threshold             = 1000
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <@${var.slack_mention}>"
}

// 内容：Synthetics Simple Browserの内部設定情報取得
//
data "newrelic_synthetics_monitor" "synthetics_browser" {
  count = length(var.newrelic_synthetics_browser)

  name = var.newrelic_synthetics_browser[count.index].name

  depends_on = [
    newrelic_synthetics_monitor.synthetics_browser
  ]
}

// 監視メトリクス：SyntheticRequest duration
// 内容：この要求の合計時間 (ミリ秒単位)。
//
// 確認：Simple Browserのdurationだと数秒以上になってしまうが、監視した方が良いものなのか確認する。SyntheticCheck、SyntheticRequestどっち？
resource "newrelic_nrql_alert_condition" "synthetics_browser_alert" {
  count = length(var.newrelic_synthetics_browser)

  policy_id = newrelic_alert_policy.policy.id
  name      = "[Synthetics Simple Browser] \"${var.newrelic_synthetics_browser[count.index].uri}\" レスポンスタイム監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(duration) FROM SyntheticCheck WHERE location = 'AWS_AP_NORTHEAST_1' AND monitorId = '${data.newrelic_synthetics_monitor.synthetics_browser[count.index].id}'"
  }
  critical {
    operator              = "above"
    threshold             = 1000
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <@${var.slack_mention}>"
}

// 内容：FAILEDの発生を監視。
//
resource "newrelic_nrql_alert_condition" "synthetics_failed_count" {
  policy_id = newrelic_alert_policy.policy.id
  name      = "[Synthetics] FAILED監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT count(result) FROM SyntheticCheck WHERE result = 'FAILED' FACET monitorName"
  }
  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <@${var.slack_mention}>"
}
