data "aws_caller_identity" "self" {}

resource "newrelic_nrql_alert_condition" "ses_send_24hour" {
  policy_id = var.policy_id
  name      = "[SES] 送信クオータ(24時間当たりの送信数)"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT count(aws.ses.Delivery) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id})"
  }

  critical {
    operator              = "above"
    threshold             = 8400000
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}

resource "newrelic_nrql_alert_condition" "ses_send_1min" {
  policy_id = var.policy_id
  name      = "[SES] 送信レート(1秒当たりの送信数)"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT count(aws.ses.Delivery) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id})"
  }

  critical {
    operator              = "above"
    threshold             = 200
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}
