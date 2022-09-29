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

module "metricstream" {
  source = "../../modules/metricstream"

  nr_external_id = local.nr_account_id
  nr_license_key = local.nr_license_key
}

module "logstream" {
  source = "../../modules/logstream"

  nr_license_key = local.nr_license_key
}
