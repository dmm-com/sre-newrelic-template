terraform {
  required_version = "~> 1.1.0"

  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 2.45.0"
    }
  }
}

provider "newrelic" {
  region     = "US"
  account_id = local.nr_account_id
  api_key    = local.nr_license_key
}

module "dashboard_aws_newrelic_charge" {
  source = "../../modules/aws_newrelic_charge"

  nr_account_id  = local.nr_account_id
  nr_license_key = local.nr_license_key

  exchange_rate = local.exchange_rate
}

module "dashboard_core_web_vitals" {
  source = "../../modules/core_web_vitals"

  nr_account_id  = local.nr_account_id
  nr_license_key = local.nr_license_key

  core_web_vitals_domain_name = local.core_web_vitals_domain_name
}

module "dashboard_circleci" {
  source = "../../modules/circleci"

  nr_account_id  = local.nr_account_id
  nr_license_key = local.nr_license_key

  circleci_organization_name = local.circleci_organization_name
}
