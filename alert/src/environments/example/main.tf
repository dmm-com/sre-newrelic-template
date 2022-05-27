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

  nr_external_id = local.nr_account_id
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

module "alert_synthetics" {
  source = "../../modules/synthetics"

  policy_id     = module.alert_policy.newrelic_alert_policy_policy_id
  slack_mention = local.slack_mention

  newrelic_synthetics_ping = [
    {
      name                      = "[DMM] TopPage (ping)"
      status                    = "ENABLED"
      uri                       = "https://www.dmm.com/"
      validation_string         = "" // レスポンスが正しいかチェックする時用のバリデーション文字列
      verify_ssl                = true
      bypass_head_request       = false // pingチェックのときデフォルトのHEADリクエストをスキップし、代わりにGETリクエストを使用する
      treat_redirect_as_failure = false
    },
    {
      name                      = "[FANZA] TopPage (ping)"
      status                    = "ENABLED"
      uri                       = "https://www.dmm.co.jp/"
      validation_string         = "動画"
      verify_ssl                = true
      bypass_head_request       = false
      treat_redirect_as_failure = false
    }
  ]

  newrelic_synthetics_browser = [
    {
      name                = "[DMM] TopPage (browser)"
      status              = "ENABLED"
      uri                 = "https://www.dmm.com/"
      validation_string   = "電子書籍"
      verify_ssl          = true
      bypass_head_request = false
    },
    {
      name                = "[FANZA] TopPage (browser)"
      status              = "ENABLED"
      uri                 = "https://www.dmm.co.jp/"
      validation_string   = "動画"
      verify_ssl          = true
      bypass_head_request = false
    }
  ]
}
