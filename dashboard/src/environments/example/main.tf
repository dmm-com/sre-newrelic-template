terraform {
  required_version = "~> 1.11.0"

  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.58.0"
    }
  }

  backend "s3" {}
}

provider "newrelic" {
  region     = "US"
  account_id = var.nr_account_id
  api_key    = var.nr_api_key
}

module "dashboard_aws_newrelic_charge" {
  source = "../../modules/aws_newrelic_charge"

  nr_account_id = var.nr_account_id

  exchange_rate = local.exchange_rate
}

module "dashboard_core_web_vitals" {
  source = "../../modules/core_web_vitals"

  nr_account_id = var.nr_account_id

  core_web_vitals_domain_name = local.core_web_vitals_domain_name
}

module "dashboard_circleci" {
  source = "../../modules/circleci"

  nr_account_id = var.nr_account_id

  circleci_organization_name = local.circleci_organization_name
}
