// 内容：APMのサーバー側レスポンスタイム監視。95パーセンタイル。（秒）
//
resource "newrelic_nrql_alert_condition" "apm_transaction_duration_average" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"

  description = "Attention <@${var.slack_mention}>"

  name                         = "[APM] サーバー レスポンスタイム監視"
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT percentile(duration, 95) FROM Transaction FACET appName EXTRAPOLATE"
  }
  critical {
    operator              = "above"
    threshold             = 0.5
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 内容：APMのデータベース側レスポンスタイム監視。95パーセンタイル。（秒）
//
resource "newrelic_nrql_alert_condition" "apm_transaction_database_duration_average" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"

  description = "Attention <@${var.slack_mention}>"

  name                         = "[APM] データベース レスポンスタイム監視"
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT percentile(databaseDuration, 95) FROM Transaction FACET appName EXTRAPOLATE"
  }
  critical {
    operator              = "above"
    threshold             = 0.5
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 内容：APMの外部サービス側レスポンスタイム監視。（秒）
//
resource "newrelic_nrql_alert_condition" "apm_external_duration_average" {
  policy_id          = newrelic_alert_policy.policy.id
  type               = "baseline"
  baseline_direction = "upper_only"

  description = "Attention <@${var.slack_mention}>"

  name                         = "[APM] 外部サービス レスポンスタイム監視（試験的）"
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "FROM Metric SELECT average(newrelic.timeslice.value, exclusiveTime: true) WHERE appName LIKE '${var.apm_app_name_prefix}' WITH METRIC_FORMAT 'External/{externalHost}/all' FACET appName, externalHost"
  }
  critical {
    operator              = "above"
    threshold             = 100
    threshold_duration    = 600
    threshold_occurrences = "ALL"
  }
  warning {
    operator              = "above"
    threshold             = 20
    threshold_duration    = 600
    threshold_occurrences = "ALL"
  }
}

// 内容：APMの5xxエラー率監視。
//
resource "newrelic_nrql_alert_condition" "apm_transaction_http_response_code_5xx_percentage" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"

  description = "Attention <@${var.slack_mention}>"

  name                         = "[APM] 5xx エラー率監視"
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "FROM Transaction SELECT percentage(count(*), WHERE httpResponseCode LIKE '5%%') FACET appName, name EXTRAPOLATE"
  }
  critical {
    operator              = "above"
    threshold             = 1
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}
