data "aws_caller_identity" "self" {}

#
# Firehose ログ出力先の S3 バケット作成
#
resource "aws_s3_bucket" "newrelic_log_stream_backup_ap_northeast_1" {
  bucket = "${data.aws_caller_identity.self.account_id}-newrelic-aws-log-stream-backup-ap-northeast-1"
}

resource "aws_s3_bucket_public_access_block" "newrelic_log_stream_backup_ap_northeast_1" {
  bucket = aws_s3_bucket.newrelic_log_stream_backup_ap_northeast_1.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
