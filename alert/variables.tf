// New Relic
variable "nr_account_id" {
  type = number
}
variable "nr_api_key" {
  type = string
}
variable "nr_external_id" {
  type = string
}

// AWS
variable "aws_region" {
  type = string
}
variable "aws_access_key" {
  type = string
}
variable "aws_secret_key" {
  type = string
}

// Alert
variable "alert_policy_name" {
  type = string
}

// Channel
variable "alert_slack_channel" {
  type = object({
    name    = string
    url     = string
    channel = string
  })
}

// Slack
variable "slack_mention" {
  type = string
}

// Synthetics
variable "newrelic_synthetics_ping" {
  type = list(object({
    name                      = string
    status                    = string
    uri                       = string
    validation_string         = string
    verify_ssl                = bool
    bypass_head_request       = bool
    treat_redirect_as_failure = bool
  }))
  default = []
}
variable "newrelic_synthetics_browser" {
  type = list(object({
    name                = string
    status              = string
    uri                 = string
    validation_string   = string
    verify_ssl          = bool
    bypass_head_request = bool
  }))
  default = []
}

// EC2 alerts
variable "ec2_network_bandwidth_used_percent_alerts" {
  type = list(object({
    max_limit_bandwidth_mbps = number
    metrics_interval_minutes = number
  }))
  default = []
}

// APM alerts
variable "apm_app_name_prefix" {
  type = string
}
