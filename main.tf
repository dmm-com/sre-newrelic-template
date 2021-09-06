variable "nr_account_id" {
  type = number
}
variable "nr_api_key" {
  type= string
}
variable "nr_region" {
  type = string
  default = "US"
}

terraform {
  required_version = "1.0.6"

  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "2.25.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "3.57.0"
    }
  }
}

provider "newrelic" {
  account_id = var.nr_account_id
  api_key = var.nr_api_key
  region = var.nr_region
}

provider "aws" {
  region = var.aws_region
}
