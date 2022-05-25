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
  account_id = var.nr_account_id
  api_key    = var.nr_license_key
}
