terraform {
  required_version = "~> 1.10.0"

  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.54.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.83.0"
    }
  }

  backend "s3" {}
}

provider "newrelic" {
  region     = "US"
  account_id = var.nr_account_id
  api_key    = var.nr_api_key
}

provider "aws" {
  region = "ap-northeast-1"
}

module "alert_workflows" {
  source = "../../modules/workflows"

  create_email_notification = local.create_email_notification
  create_slack_notification = local.create_slack_notification

  nr_account_id             = var.nr_account_id
  email_destination_name    = local.alert_to_email.destination_name
  email_destination_address = local.alert_to_email.destination_address
  slack_destination_id      = local.alert_to_slack.destination_id
  slack_channel_name        = local.alert_to_slack.channel_name
  slack_channel_id          = local.alert_to_slack.channel_id
  workflow_name             = module.alert_policy.newrelic_alert_policy_policy_name
  policy_id                 = module.alert_policy.newrelic_alert_policy_policy_id
}

module "alert_policy" {
  source = "../../modules/alert-policy"

  alert_policy_name = local.alert_policy_name
}

module "alert_apm" {
  source = "../../modules/apm"

  policy_id           = module.alert_policy.newrelic_alert_policy_policy_id
  apm_app_name_prefix = local.apm_app_name_prefix
  slack_mention       = local.slack_mention
}

module "alert_cloudfront" {
  source = "../../modules/cloudfront"

  policy_id     = module.alert_policy.newrelic_alert_policy_policy_id
  slack_mention = local.slack_mention
}

module "alert_ecs" {
  source = "../../modules/ecs"

  policy_id     = module.alert_policy.newrelic_alert_policy_policy_id
  slack_mention = local.slack_mention
}

module "alert_elasticache" {
  source = "../../modules/elasticache"

  policy_id     = module.alert_policy.newrelic_alert_policy_policy_id
  slack_mention = local.slack_mention
}

module "alert_elb" {
  source = "../../modules/elb"

  policy_id     = module.alert_policy.newrelic_alert_policy_policy_id
  slack_mention = local.slack_mention
}

module "alert_natgateway" {
  source = "../../modules/natgateway"

  policy_id     = module.alert_policy.newrelic_alert_policy_policy_id
  slack_mention = local.slack_mention
}

module "alert_rds" {
  source = "../../modules/rds"

  policy_id     = module.alert_policy.newrelic_alert_policy_policy_id
  slack_mention = local.slack_mention
}

module "alert_ec2" {
  source = "../../modules/ec2"

  policy_id     = module.alert_policy.newrelic_alert_policy_policy_id
  slack_mention = local.slack_mention
}

module "alert_synthetics_ping" {
  source = "../../modules/synthetics"

  policy_id     = module.alert_policy.newrelic_alert_policy_policy_id
  slack_mention = local.slack_mention

  count = length(local.newrelic_synthetics_ping)
  newrelic_synthetics_ping = [
    {
      name                      = local.newrelic_synthetics_ping[count.index].name
      status                    = local.newrelic_synthetics_ping[count.index].status
      uri                       = local.newrelic_synthetics_ping[count.index].uri
      validation_string         = local.newrelic_synthetics_ping[count.index].validation_string
      verify_ssl                = local.newrelic_synthetics_ping[count.index].verify_ssl
      bypass_head_request       = local.newrelic_synthetics_ping[count.index].bypass_head_request
      treat_redirect_as_failure = local.newrelic_synthetics_ping[count.index].treat_redirect_as_failure
    }
  ]
}

module "alert_synthetics_browser" {
  source = "../../modules/synthetics"

  policy_id     = module.alert_policy.newrelic_alert_policy_policy_id
  slack_mention = local.slack_mention

  count = length(local.newrelic_synthetics_browser)
  newrelic_synthetics_browser = [
    {
      name              = local.newrelic_synthetics_browser[count.index].name
      status            = local.newrelic_synthetics_browser[count.index].status
      uri               = local.newrelic_synthetics_browser[count.index].uri
      validation_string = local.newrelic_synthetics_browser[count.index].validation_string
      verify_ssl        = local.newrelic_synthetics_browser[count.index].verify_ssl
    }
  ]
}
