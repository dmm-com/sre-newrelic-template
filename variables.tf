variable "nr_account_id" {
  type = number
}
variable "nr_api_key" {
  type = string
}
variable "nr_region" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "newrelic_synthetics_ping" {
  type = list(object({
    name                      = string
    frequency                 = number
    status                    = string
    locations                 = list(string)
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
    frequency           = number
    status              = string
    locations           = list(string)
    uri                 = string
    validation_string   = string
    verify_ssl          = bool
    bypass_head_request = bool
  }))
  default = []
}

variable "aws_account_ids" {
  type    = list(string)
  default = []
}

variable "alert_slack_channel" {
  type = list(object({
    name    = string
    url     = string
    channel = string
  }))
  default = []
}

variable "cpu_alerts" {
  type = list(object({
    name          = string
    ec2_tag_key   = string
    ec2_tag_value = string
  }))
  default = []
}

// New Relic の infrastructure agent を使用
variable "alive_alert_names" {
  type    = list(string)
  default = []
}

// New Relic の infrastructure agent を使用
variable "cpuiowait_alert_names" {
  type    = list(string)
  default = []
}

// New Relic の infrastructure agent を使用
variable "disk_alert_names" {
  type    = list(string)
  default = []
}

// New Relic の infrastructure agent を使用
variable "load_average_alert_names" {
  type    = list(string)
  default = []
}

// New Relic の infrastructure agent を使用
variable "timesync_alert_names" {
  type    = list(string)
  default = []
}

// New Relic の infrastructure agent を使用
variable "memory_alert_names" {
  type    = list(string)
  default = []
}

// New Relic の infrastructure agent を使用
variable "alert_network" {
  type = list(object({
    name                = string
    max_limit_bandwidth = number
  }))
  default = []
}

variable "rds_alive_alert_names" {
  type    = list(string)
  default = []
}

variable "rds_replica_lag_alert_names" {
  type    = list(string)
  default = []
}

variable "rds_connection_alert_names" {
  type    = list(string)
  default = []
}
