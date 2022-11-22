#
# NewRelic にメトリクスを送信する Firehose 配信ストリームを作成
# https://docs.newrelic.com/docs/infrastructure/amazon-integrations/connect/aws-metric-stream-setup#manual-setup
#
resource "aws_kinesis_firehose_delivery_stream" "newrelic_metric_stream" {
  name        = "newrelic-metric-stream"
  destination = "http_endpoint"

  http_endpoint_configuration {
    name               = "New Relic"
    access_key         = var.nr_license_key
    buffering_interval = 60
    buffering_size     = 1
    retry_duration     = 60
    role_arn           = var.aws_iam_role_firehose_cloudwatch_metric_stream_for_newrelic_arn
    s3_backup_mode     = "FailedDataOnly"
    url                = "https://aws-api.newrelic.com/cloudwatch-metrics/v1"

    request_configuration {
      content_encoding = "GZIP"
    }
  }

  s3_configuration {
    bucket_arn         = var.aws_s3_bucket_newrelic_metric_stream_backup_arn
    role_arn           = var.aws_iam_role_firehose_cloudwatch_metric_stream_for_newrelic_arn
    buffer_interval    = 60
    buffer_size        = 1
    compression_format = "GZIP"
  }
}

#
# Firehose にメトリクスを送信する MetricStream を作成
# https://docs.newrelic.com/docs/infrastructure/amazon-integrations/connect/aws-metric-stream-setup#manual-setup
#
resource "aws_cloudwatch_metric_stream" "cloudwatch_metric_stream_for_newrelic" {
  name          = "newrelic-metric-stream"
  firehose_arn  = aws_kinesis_firehose_delivery_stream.newrelic_metric_stream.arn
  output_format = "opentelemetry0.7"
  role_arn      = var.aws_iam_role_cloudwatch_metric_stream_for_newrelic_arn
}
