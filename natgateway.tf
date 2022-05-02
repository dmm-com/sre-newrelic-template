resource "newrelic_nrql_alert_condition" "natgateway_packets_drop_count" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.natgateway_packets_drop_count_alerts)
  name                         = var.natgateway_packets_drop_count_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "FROM Metric SELECT sum(`aws.natgateway.PacketsDropCount`) WHERE `aws.accountId` IN (${data.aws_caller_identity.self.account_id}) FACET `aws.natgateway.NatGatewayId`"
  }
  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}

resource "newrelic_nrql_alert_condition" "natgateway_error_port_allocation" {
  policy_id      = newrelic_alert_policy.policy.id
  type           = "static"
  value_function = "single_value"

  description = "Attention <@${var.slack_mention}>"

  count                        = length(var.natgateway_error_port_allocation_alerts)
  name                         = var.natgateway_error_port_allocation_alerts[count.index].name
  violation_time_limit_seconds = 3600

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query             = "FROM Metric SELECT sum(`aws.natgateway.ErrorPortAllocation`) WHERE `aws.accountId` IN (${data.aws_caller_identity.self.account_id}) FACET `aws.natgateway.NatGatewayId`"
  }
  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}
