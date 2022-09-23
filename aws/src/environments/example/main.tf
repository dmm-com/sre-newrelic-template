terraform {
  required_version = "~> 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.14.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = local.aws_region
}

module "metricstream" {
  source = "../../modules/metricstream"

  nr_external_id = local.nr_account_id
}
