// 内容：SyntheticsのPing監視
//
resource "newrelic_synthetics_monitor" "synthetics_ping" {
  count = length(var.newrelic_synthetics_ping)

  name             = var.newrelic_synthetics_ping[count.index].name
  type             = "SIMPLE"
  period           = "EVERY_MINUTE"
  locations_public = ["AP_NORTHEAST_1", "US_WEST_1", "US_EAST_1"]
  status           = var.newrelic_synthetics_ping[count.index].status

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

  name             = var.newrelic_synthetics_browser[count.index].name
  type             = "BROWSER"
  period           = "EVERY_MINUTE"
  locations_public = ["AP_NORTHEAST_1", "US_WEST_1", "US_EAST_1"]
  status           = var.newrelic_synthetics_browser[count.index].status

  runtime_type         = "CHROME_BROWSER"
  runtime_type_version = "100"
  script_language      = "JAVASCRIPT"

  uri               = var.newrelic_synthetics_browser[count.index].uri
  validation_string = var.newrelic_synthetics_browser[count.index].validation_string
  verify_ssl        = var.newrelic_synthetics_browser[count.index].verify_ssl
}

// 監視メトリクス：SyntheticCheck duration
// 内容：この要求の合計時間 (ミリ秒単位)。
//
resource "newrelic_nrql_alert_condition" "synthetics_ping_alert" {
  count = length(var.newrelic_synthetics_ping)

  policy_id = var.policy_id
  name      = "[Synthetics Ping] ${var.newrelic_synthetics_ping[count.index].uri} レスポンスタイム監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(duration) FROM SyntheticCheck WHERE location = 'AWS_AP_NORTHEAST_1' AND entityGuid = '${newrelic_synthetics_monitor.synthetics_ping[count.index].id}'"
  }
  critical {
    operator              = "above"
    threshold             = 1000
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}

// 監視メトリクス：SyntheticCheck duration
// 内容：この要求の合計時間 (ミリ秒単位)。
//
resource "newrelic_nrql_alert_condition" "synthetics_browser_alert" {
  count = length(var.newrelic_synthetics_browser)

  policy_id = var.policy_id
  name      = "[Synthetics Simple Browser] ${var.newrelic_synthetics_browser[count.index].uri} レスポンスタイム監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(duration) FROM SyntheticCheck WHERE location = 'AWS_AP_NORTHEAST_1' AND entityGuid = '${newrelic_synthetics_monitor.synthetics_browser[count.index].id}'"
  }
  critical {
    operator              = "above"
    threshold             = 3000
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}

// 内容：FAILEDの発生を監視。
//
resource "newrelic_nrql_alert_condition" "synthetics_ping_failed_count" {
  count = length(var.newrelic_synthetics_ping)

  policy_id = var.policy_id
  name      = "[Synthetics Ping] ${var.newrelic_synthetics_ping[count.index].uri} FAILED監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT count(result) FROM SyntheticCheck WHERE result = 'FAILED' AND entityGuid = '${newrelic_synthetics_monitor.synthetics_ping[count.index].id}'"
  }
  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  close_violations_on_expiration = true
  expiration_duration            = 60

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}

// 内容：FAILEDの発生を監視。
//
resource "newrelic_nrql_alert_condition" "synthetics_browser_failed_count" {
  count = length(var.newrelic_synthetics_browser)

  policy_id = var.policy_id
  name      = "[Synthetics Simple Browser] ${var.newrelic_synthetics_browser[count.index].uri} FAILED監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT count(result) FROM SyntheticCheck WHERE result = 'FAILED' AND entityGuid = '${newrelic_synthetics_monitor.synthetics_browser[count.index].id}'"
  }
  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  close_violations_on_expiration = true
  expiration_duration            = 60

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}
