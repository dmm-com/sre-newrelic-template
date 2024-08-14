data "aws_caller_identity" "self" {}
data "aws_iam_account_alias" "current" {}

#
# NewRelic AWS インテグレーション用の IAM ロール作成
# https://docs.newrelic.com/docs/infrastructure/amazon-integrations/connect/connect-aws-new-relic-infrastructure-monitoring/
#
data "aws_iam_policy_document" "newrelic_integration_assume_policy" {
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

resource "aws_iam_role" "newrelic_integration" {
  name               = "NewRelicInfrastructure-Integrations"
  description        = "NewRelic AWS Integration"
  assume_role_policy = data.aws_iam_policy_document.newrelic_integration_assume_policy.json
}

resource "aws_iam_policy" "newrelic_integration_policy" {
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

resource "aws_iam_role_policy_attachment" "newrelic_integration_billing" {
  role       = aws_iam_role.newrelic_integration.name
  policy_arn = aws_iam_policy.newrelic_integration_policy.arn
}

resource "aws_iam_role_policy_attachment" "newrelic_integration" {
  role       = aws_iam_role.newrelic_integration.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "time_sleep" "newrelic_integration_create_role_after_wait_30_seconds" {
  create_duration = "30s"

  depends_on = [
    aws_iam_role.newrelic_integration
  ]
}

#
# Firehose ログ出力先の S3 バケット作成
#
resource "aws_s3_bucket" "newrelic_metric_stream_backup" {
  bucket = "${data.aws_caller_identity.self.account_id}-newrelic-aws-metric-stream-backup"
}

resource "aws_s3_bucket_public_access_block" "newrelic_metric_stream_backup" {
  bucket = aws_s3_bucket.newrelic_metric_stream_backup.id

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
      aws_s3_bucket.newrelic_metric_stream_backup.arn,
      "${aws_s3_bucket.newrelic_metric_stream_backup.arn}/*"
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
      "arn:aws:firehose:*:${data.aws_caller_identity.self.account_id}:deliverystream/newrelic-metric-stream",
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
# NewRelic と AWS のアカウントリンク設定
#
resource "newrelic_cloud_aws_link_account" "newrelic_cloud_integration_cloudwatch_metric_stream" {
  name                   = "${data.aws_caller_identity.self.account_id}-${data.aws_iam_account_alias.current.account_alias}-metric-streams"
  arn                    = aws_iam_role.newrelic_integration.arn
  metric_collection_mode = "PUSH"

  depends_on = [
    time_sleep.newrelic_integration_create_role_after_wait_30_seconds
  ]
}
