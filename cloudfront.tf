resource "newrelic_nrql_alert_condition" "cloudfront_4xx" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  count                        = length(var.cloudfront_4xx_alerts)
  name                         = var.cloudfront_4xx_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "FROM Metric SELECT average(`aws.cloudfront.4xxErrorRate`) WHERE `aws.accountId` IN (${var.aws_account_id}) FACET `aws.cloudfront.DistributionId`"
  }
  critical {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}
