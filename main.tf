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
  account_id = var.nr_account_id
  api_key    = var.nr_api_key
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

data "aws_caller_identity" "self" {}

// New Relic alert setting
resource "newrelic_alert_policy" "policy" {
  name = var.alert_policy_name
}

resource "newrelic_alert_channel" "channel" {
  type = "slack"
  name = var.alert_slack_channel.name

  config {
    url     = var.alert_slack_channel.url
    channel = var.alert_slack_channel.channel
  }
}

resource "newrelic_alert_policy_channel" "slack_channel" {
  policy_id   = newrelic_alert_policy.policy.id
  channel_ids = [newrelic_alert_channel.channel.id]
}
