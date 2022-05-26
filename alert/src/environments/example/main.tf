terraform {
  required_version = ">= 1.0.6"

  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 2.45.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.14.0"
    }
  }
}

provider "newrelic" {
  region     = "US"
  account_id = local.nr_account_id
  api_key    = local.nr_api_key
}

provider "aws" {
  region = local.aws_region
}

module "newrelic-iam" {
  source = "../../modules/newrelic-iam"

  nr_external_id = local.nr_external_id
}

module "alert_policy" {
  source = "../../modules/alert-policy"

  alert_policy_name = local.alert_policy_name
  alert_slack_channel = {
    name    = local.alert_slack_channel.name
    url     = local.alert_slack_channel.url
    channel = local.alert_slack_channel.channel
  }
  slack_mention = local.slack_mention
}

module "alert_apm" {
  source = "../../modules/apm"

  policy_id           = module.alert_policy.newrelic_alert_policy_policy_id
  apm_app_name_prefix = "[prod]%"
  slack_mention       = local.slack_mention
}

module "alert_cloudfront" {
  source = "../../modules/cloudfront"

  policy_id     = module.alert_policy.newrelic_alert_policy_policy_id
  slack_mention = local.slack_mention
}
