terraform {
  required_version = "1.0.6"
}

terraform {
  required_version = "1.0.6"

  required_providers {
    newrelic = {
      source = "newrelic/newrelic"
      version = "2.25.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "3.57.0"
    }
  }
}

provider "newrelic" {}

provider "aws" {}