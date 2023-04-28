output "aws_iam_role_firehose_cloudwatch_metric_stream_for_newrelic_arn" {
  value = aws_iam_role.firehose_cloudwatch_metric_stream_for_newrelic.arn
}

output "aws_s3_bucket_newrelic_metric_stream_backup_arn" {
  value = aws_s3_bucket.newrelic_metric_stream_backup.arn
}

output "aws_iam_role_cloudwatch_metric_stream_for_newrelic_arn" {
  value = aws_iam_role.cloudwatch_metric_stream_for_newrelic.arn
}
