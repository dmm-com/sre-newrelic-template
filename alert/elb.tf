// 監視メトリクス：HTTPCode_ELB_5XX_Count (ALB)
// 内容：ロードバランサーから送信される HTTP 5XX サーバーエラーコードの数。
//
resource "newrelic_nrql_alert_condition" "elb_http_code_elb_5xx_count" {
  policy_id = newrelic_alert_policy.policy.id
  name      = "[ALB] LB 5xx エラー数監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT sum(aws.applicationelb.HTTPCode_ELB_5XX_Count) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.applicationelb.LoadBalancer"
  }
  critical {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <@${var.slack_mention}>"
}

// 監視メトリクス：RejectedConnectionCount (ALB)
// 内容：ロードバランサーが接続の最大数に達したため、拒否された接続の数。
//
resource "newrelic_nrql_alert_condition" "elb_rejected_connection_count" {
  policy_id = newrelic_alert_policy.policy.id
  name      = "[ALB] LB リクエスト拒否数監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT sum(aws.applicationelb.RejectedConnectionCount) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.applicationelb.LoadBalancer"
  }
  critical {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <@${var.slack_mention}>"
}

// 監視メトリクス：HTTPCode_Target_5XX_Count (ALB)
// 内容：ターゲットによって生成された HTTP 5XX 応答コードの数。
//
resource "newrelic_nrql_alert_condition" "elb_http_code_target_5xx_count" {
  policy_id = newrelic_alert_policy.policy.id
  name      = "[ALB] Target 5xx エラー数監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT sum(aws.applicationelb.HTTPCode_Target_5XX_Count) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.applicationelb.TargetGroup"
  }
  critical {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <@${var.slack_mention}>"
}

// 監視メトリクス：TargetConnectionErrorCount (ALB)
// 内容：ロードバランサーとターゲット間で正常に確立されなかった接続数。
//
resource "newrelic_nrql_alert_condition" "elb_target_connection_error_count" {
  policy_id = newrelic_alert_policy.policy.id
  name      = "[ALB] Target 接続確立エラー数監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT sum(aws.applicationelb.TargetConnectionErrorCount) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.applicationelb.TargetGroup"
  }
  critical {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <@${var.slack_mention}>"
}

// 監視メトリクス：UnHealthyHostCount (ALB)
// 内容：異常と見なされるターゲットの数。
//
resource "newrelic_nrql_alert_condition" "elb_alb_unhealthy_host_count" {
  policy_id = newrelic_alert_policy.policy.id
  name      = "[ALB] Target 異常数監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(aws.applicationelb.UnHealthyHostCount) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.applicationelb.TargetGroup"
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

// 監視メトリクス：PortAllocationErrorCount (NLB)
// 内容：クライアント IP 変換操作中の一時ポート割り当てエラーの総数。
//
resource "newrelic_nrql_alert_condition" "elb_port_allocation_error_count" {
  policy_id = newrelic_alert_policy.policy.id
  name      = "[NLB] ポート割り当てエラー数監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT sum(aws.networkelb.PortAllocationErrorCount) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.networkelb.LoadBalancer"
  }
  critical {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <@${var.slack_mention}>"
}

// 監視メトリクス：UnHealthyHostCount (NLB)
// 内容：異常と見なされるターゲットの数。
//
resource "newrelic_nrql_alert_condition" "elb_nlb_unhealthy_host_count" {
  policy_id = newrelic_alert_policy.policy.id
  name      = "[NLB] Target 異常数監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "SELECT average(aws.networkelb.UnHealthyHostCount) FROM Metric WHERE aws.accountId IN (${data.aws_caller_identity.self.account_id}) FACET aws.networkelb.TargetGroup"
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
