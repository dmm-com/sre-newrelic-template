resource "newrelic_nrql_alert_condition" "cloudfront_4xx" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.cloudfront_4xx_alerts)
  name                         = var.cloudfront_4xx_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "FROM Metric SELECT average(`aws.cloudfront.4xxErrorRate`) WHERE `aws.accountId` IN (${data.aws_caller_identity.self.account_id}) FACET `aws.cloudfront.DistributionId`"
  }
  critical {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "cloudfront_5xx" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.cloudfront_5xx_alerts)
  name                         = var.cloudfront_5xx_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "FROM Metric SELECT average(`aws.cloudfront.5xxErrorRate`) WHERE `aws.accountId` IN (${data.aws_caller_identity.self.account_id}) FACET `aws.cloudfront.DistributionId`"
  }
  critical {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "cloudfront_origin_latency" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.cloudfront_origin_latency_alerts)
  name                         = var.cloudfront_origin_latency_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "FROM Metric SELECT average(`aws.cloudfront.OriginLatency`) WHERE `aws.accountId` IN (${data.aws_caller_identity.self.account_id}) FACET `aws.cloudfront.DistributionId`"
  }
  critical {
    operator              = "above"
    threshold             = 200
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}
