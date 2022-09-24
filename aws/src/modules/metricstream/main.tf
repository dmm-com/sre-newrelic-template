data "aws_caller_identity" "self" {}
data "aws_iam_account_alias" "current" {}

#
# NewRelic AWS インテグレーション用の IAM ロール作成
# https://docs.newrelic.com/docs/infrastructure/amazon-integrations/connect/connect-aws-new-relic-infrastructure-monitoring/
#
resource "aws_iam_role" "newrelic" {
  name               = "NewRelicInfrastructure-Integrations"
  description        = "NewRelic AWS Integration"
  assume_role_policy = data.aws_iam_policy_document.assume_policy.json
}

data "aws_iam_policy_document" "assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["754728514883"] # NewRelicのAWSアカウント
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = ["${var.nr_external_id}"] # NewRelicのExternalId
    }
  }
}

resource "aws_iam_policy" "policy" {
  name        = "NewRelicBudget"
  path        = "/"
  description = "NewRelic Policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "budgets:ViewBudget",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "billing" {
  role       = aws_iam_role.newrelic.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_role_policy_attachment" "newrelic" {
  role       = aws_iam_role.newrelic.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

#
# Firehose ログ出力先の S3 バケット作成
#
resource "aws_s3_bucket" "newrelic_metric_stream_backup_ap_northeast_1" {
  bucket = "${data.aws_caller_identity.self.account_id}-newrelic-aws-metric-stream-backup-ap-northeast-1"
}

resource "aws_s3_bucket_public_access_block" "newrelic_metric_stream_backup_ap_northeast_1" {
  bucket = aws_s3_bucket.newrelic_metric_stream_backup_ap_northeast_1.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#
# Firehose にアタッチする IAM ロール作成
#
data "aws_iam_policy_document" "firehose_cloudwatch_metric_stream_for_newrelic_assume_role" {
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

resource "aws_iam_role" "firehose_cloudwatch_metric_stream_for_newrelic" {
  name               = "firehose-cloudwatch-metric-stream-for-newrelic"
  assume_role_policy = data.aws_iam_policy_document.firehose_cloudwatch_metric_stream_for_newrelic_assume_role.json
}

data "aws_iam_policy_document" "firehose_cloudwatch_metric_stream_for_newrelic" {
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
      aws_s3_bucket.newrelic_metric_stream_backup_ap_northeast_1.arn,
      "${aws_s3_bucket.newrelic_metric_stream_backup_ap_northeast_1.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "firehose_cloudwatch_metric_stream_for_newrelic" {
  name   = "firehose-cloudwatch-metric-stream-for-newrelic"
  policy = data.aws_iam_policy_document.firehose_cloudwatch_metric_stream_for_newrelic.json
}

resource "aws_iam_role_policy_attachment" "firehose_cloudwatch_metric_stream_for_newrelic" {
  role       = aws_iam_role.firehose_cloudwatch_metric_stream_for_newrelic.name
  policy_arn = aws_iam_policy.firehose_cloudwatch_metric_stream_for_newrelic.arn
}

#
# NewRelic にメトリクスを送信する Firehose 配信ストリームを作成
# https://docs.newrelic.com/docs/infrastructure/amazon-integrations/connect/aws-metric-stream-setup#manual-setup
#
resource "aws_kinesis_firehose_delivery_stream" "newrelic_metric_stream_ap_northeast_1" {
  name        = "newrelic-metric-stream"
  destination = "http_endpoint"

  http_endpoint_configuration {
    name               = "New Relic"
    access_key         = var.nr_license_key
    buffering_interval = 60
    buffering_size     = 1
    retry_duration     = 60
    role_arn           = aws_iam_role.firehose_cloudwatch_metric_stream_for_newrelic.arn
    s3_backup_mode     = "FailedDataOnly"
    url                = "https://aws-api.newrelic.com/cloudwatch-metrics/v1"

    request_configuration {
      content_encoding = "GZIP"
    }
  }

  s3_configuration {
    bucket_arn         = aws_s3_bucket.newrelic_metric_stream_backup_ap_northeast_1.arn
    role_arn           = aws_iam_role.firehose_cloudwatch_metric_stream_for_newrelic.arn
    buffer_interval    = 60
    buffer_size        = 1
    compression_format = "GZIP"
  }
}

#
# MetricStream にアタッチする IAM ロール作成
#
data "aws_iam_policy_document" "cloudwatch_metric_stream_for_newrelic_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["streams.metrics.cloudwatch.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "cloudwatch_metric_stream_for_newrelic" {
  name               = "cloudwatch-metric-stream-for-newrelic"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_metric_stream_for_newrelic_assume_role.json
}

data "aws_iam_policy_document" "cloudwatch_metric_stream_for_newrelic" {
  statement {
    sid    = ""
    effect = "Allow"

    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch",
    ]

    resources = [
      aws_kinesis_firehose_delivery_stream.newrelic_metric_stream_ap_northeast_1.arn
    ]
  }
}

resource "aws_iam_policy" "cloudwatch_metric_stream_for_newrelic" {
  name   = "cloudwatch-metric-stream-for-newrelic"
  policy = data.aws_iam_policy_document.cloudwatch_metric_stream_for_newrelic.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_metric_stream_for_newrelic" {
  role       = aws_iam_role.cloudwatch_metric_stream_for_newrelic.name
  policy_arn = aws_iam_policy.cloudwatch_metric_stream_for_newrelic.arn
}

#
# Firehose にメトリクスを送信する MetricStream を作成
# https://docs.newrelic.com/docs/infrastructure/amazon-integrations/connect/aws-metric-stream-setup#manual-setup
#
resource "aws_cloudwatch_metric_stream" "cloudwatch_metric_stream_for_newrelic_ap_northeast_1" {
  name          = "newrelic-metric-stream"
  firehose_arn  = aws_kinesis_firehose_delivery_stream.newrelic_metric_stream_ap_northeast_1.arn
  output_format = "opentelemetry0.7"
  role_arn      = aws_iam_role.cloudwatch_metric_stream_for_newrelic.arn
}

#
# NewRelic と AWS のアカウントリンク設定
#
resource "newrelic_cloud_aws_link_account" "foo" {
  name                   = "${data.aws_caller_identity.self.account_id}-${data.aws_iam_account_alias.current.account_alias}"
  arn                    = aws_iam_role.newrelic.arn
  metric_collection_mode = "PUSH"
}
