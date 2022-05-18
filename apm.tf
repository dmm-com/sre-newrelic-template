// 内容：APMのサーバー側レスポンスタイム監視。（秒）
//
resource "newrelic_nrql_alert_condition" "apm_transaction_duration_average" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.apm_transaction_duration_average_alerts)
  name                         = var.apm_transaction_duration_average_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(duration) FROM Transaction WHERE `aws.accountId` IN (${data.aws_caller_identity.self.account_id}) FACET appName EXTRAPOLATE"
  }
  critical {
    operator              = "above"
    threshold             = 0.5
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 内容：APMのデータベース側レスポンスタイム監視。（秒）
//
resource "newrelic_nrql_alert_condition" "apm_transaction_database_duration_average" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.apm_transaction_database_duration_average_alerts)
  name                         = var.apm_transaction_database_duration_average_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(databaseDuration) FROM Transaction WHERE `aws.accountId` IN (${data.aws_caller_identity.self.account_id}) FACET appName EXTRAPOLATE"
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
resource "newrelic_nrql_alert_condition" "apm_transaction_external_duration_average" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.apm_transaction_external_duration_average_alerts)
  name                         = var.apm_transaction_external_duration_average_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "SELECT average(externalDuration) FROM Transaction WHERE `aws.accountId` IN (${data.aws_caller_identity.self.account_id}) FACET appName EXTRAPOLATE"
  }
  critical {
    operator              = "above"
    threshold             = 0.5
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

// 内容：APMの5xxエラー率監視。
//
resource "newrelic_nrql_alert_condition" "apm_transaction_http_response_code_5xx_percentage" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.apm_transaction_http_response_code_5xx_percentage_alerts)
  name                         = var.apm_transaction_http_response_code_5xx_percentage_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "FROM Transaction SELECT percentage(count(*), WHERE httpResponseCode LIKE '5%%') WHERE `aws.accountId` IN (${data.aws_caller_identity.self.account_id}) FACET appName, name EXTRAPOLATE"
  }
  critical {
    operator              = "above"
    threshold             = 1
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}
