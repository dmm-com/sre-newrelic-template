terraform {
  required_version = "~> 1.1.0"

  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.32.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.8.0"
    }
  }

  backend "s3" {}
}

provider "newrelic" {
  region     = "US"
  account_id = local.nr_account_id
  api_key    = local.nr_api_key
}

provider "aws" {
  region = local.aws_region
}

provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

module "metricstream_common" {
  providers = {
    aws = aws.virginia
  }

  source = "../../modules/metricstream_common"

  nr_external_id = local.nr_account_id

  aws_kinesis_firehose_delivery_stream_newrelic_metric_stream_arn = module.metricstream_for_tokyo.aws_kinesis_firehose_delivery_stream_newrelic_metric_stream_arn
}

module "metricstream_for_tokyo" {
  source = "../../modules/metricstream"

  nr_license_key = var.nr_license_key

  aws_iam_role_firehose_cloudwatch_metric_stream_for_newrelic_arn = module.metricstream_common.aws_iam_role_firehose_cloudwatch_metric_stream_for_newrelic_arn
  aws_s3_bucket_newrelic_metric_stream_backup_arn                 = module.metricstream_common.aws_s3_bucket_newrelic_metric_stream_backup_arn
  aws_iam_role_cloudwatch_metric_stream_for_newrelic_arn          = module.metricstream_common.aws_iam_role_cloudwatch_metric_stream_for_newrelic_arn
}

module "metricstream_for_virginia" {
  providers = {
    aws = aws.virginia
  }

  source = "../../modules/metricstream"

  nr_license_key = var.nr_license_key

  aws_iam_role_firehose_cloudwatch_metric_stream_for_newrelic_arn = module.metricstream_common.aws_iam_role_firehose_cloudwatch_metric_stream_for_newrelic_arn
  aws_s3_bucket_newrelic_metric_stream_backup_arn                 = module.metricstream_common.aws_s3_bucket_newrelic_metric_stream_backup_arn
  aws_iam_role_cloudwatch_metric_stream_for_newrelic_arn          = module.metricstream_common.aws_iam_role_cloudwatch_metric_stream_for_newrelic_arn
}
