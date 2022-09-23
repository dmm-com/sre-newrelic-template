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

output "role_arn" {
  value = aws_iam_role.newrelic.arn
}
