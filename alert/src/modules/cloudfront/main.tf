data "aws_caller_identity" "self" {}

// 監視メトリクス：4xxErrorRate
// 内容：レスポンスの HTTP ステータスコードが 4xx であるすべてのビューワーリクエストの割合 (%)。
//
resource "newrelic_nrql_alert_condition" "cloudfront_4xx_error_rate" {
  policy_id = var.policy_id
  name      = "[CloudFront] 4xx エラー率監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "FROM Metric SELECT average(`aws.cloudfront.4xxErrorRate`) WHERE `aws.accountId` IN (${data.aws_caller_identity.self.account_id}) FACET `aws.cloudfront.DistributionId`"
  }
  critical {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}

// 監視メトリクス：5xxErrorRate
// 内容：レスポンスの HTTP ステータスコードが 5xx であるすべてのビューワーリクエストの割合 (%)。
//
resource "newrelic_nrql_alert_condition" "cloudfront_5xx_error_rate" {
  policy_id = var.policy_id
  name      = "[CloudFront] 5xx エラー率監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "FROM Metric SELECT average(`aws.cloudfront.5xxErrorRate`) WHERE `aws.accountId` IN (${data.aws_caller_identity.self.account_id}) FACET `aws.cloudfront.DistributionId`"
  }
  critical {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }

  violation_time_limit_seconds = 3600
  description                  = "Attention <${var.slack_mention}>"
}

// 監視メトリクス：OriginLatency
// 内容：CloudFront キャッシュではなくオリジンから送信されたリクエストについて、CloudFront がリクエストを受信してからネットワーク (ビューワーではなく) にレスポンスを提供し始めるまでに費やした合計時間 (ミリ秒単位)。
//
resource "newrelic_nrql_alert_condition" "cloudfront_origin_latency" {
  policy_id = var.policy_id
  name      = "[CloudFront] オリジン遅延監視"
  type      = "static"

  aggregation_window = "60"
  aggregation_method = "event_flow"
  aggregation_delay  = "120"

  nrql {
    query = "FROM Metric SELECT average(`aws.cloudfront.OriginLatency`) WHERE `aws.accountId` IN (${data.aws_caller_identity.self.account_id}) FACET `aws.cloudfront.DistributionId`"
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
