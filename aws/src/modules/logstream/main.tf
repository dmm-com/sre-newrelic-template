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

#
# Firehose にアタッチする IAM ロール作成
#
data "aws_iam_policy_document" "firehose_cloudwatch_log_stream_for_newrelic_assume_role" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "firehose_cloudwatch_log_stream_for_newrelic" {
  name               = "firehose-cloudwatch-log-stream-for-newrelic"
  assume_role_policy = data.aws_iam_policy_document.firehose_cloudwatch_log_stream_for_newrelic_assume_role.json
}

data "aws_iam_policy_document" "firehose_cloudwatch_log_stream_for_newrelic" {
  statement {
    sid    = ""
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.newrelic_log_stream_backup_ap_northeast_1.arn,
      "${aws_s3_bucket.newrelic_log_stream_backup_ap_northeast_1.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "firehose_cloudwatch_log_stream_for_newrelic" {
  name   = "firehose-cloudwatch-log-stream-for-newrelic"
  policy = data.aws_iam_policy_document.firehose_cloudwatch_log_stream_for_newrelic.json
}

resource "aws_iam_role_policy_attachment" "firehose_cloudwatch_log_stream_for_newrelic" {
  role       = aws_iam_role.firehose_cloudwatch_log_stream_for_newrelic.name
  policy_arn = aws_iam_policy.firehose_cloudwatch_log_stream_for_newrelic.arn
}
