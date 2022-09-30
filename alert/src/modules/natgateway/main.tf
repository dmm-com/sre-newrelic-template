data "aws_caller_identity" "self" {}

// 監視メトリクス：PacketsDropCount
// 内容：NAT ゲートウェイによって破棄されたパケットの数。
//
resource "newrelic_nrql_alert_condition" "natgateway_packets_drop_count" {
  policy_id = var.policy_id
  name      = "[NAT Gateway] パケットドロップ監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "FROM Metric SELECT sum(`aws.natgateway.PacketsDropCount`) WHERE `aws.accountId` IN (${data.aws_caller_identity.self.account_id}) FACET `aws.natgateway.NatGatewayId`"
  }
  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}

// 監視メトリクス：ErrorPortAllocation
// 内容：NAT ゲートウェイが送信元ポートを割り当てられなかった回数。
//
resource "newrelic_nrql_alert_condition" "natgateway_error_port_allocation" {
  policy_id = var.policy_id
  name      = "[NAT Gateway] ポート割り当てエラー監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "FROM Metric SELECT sum(`aws.natgateway.ErrorPortAllocation`) WHERE `aws.accountId` IN (${data.aws_caller_identity.self.account_id}) FACET `aws.natgateway.NatGatewayId`"
  }
  critical {
    operator              = "above"
    threshold             = 0
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}
