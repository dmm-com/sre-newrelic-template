variable "nr_account_id" {
  type = number
}
variable "nr_api_key" {
  type = string
}

variable "nr_external_id" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "alert_policy_name" {
  type = string
}

variable "alert_slack_channel" {
  type = object({
    name    = string
    url     = string
    channel = string
  })
}

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


variable "cpu_alerts" {
  type = list(object({
    name          = string
    ec2_tag_key   = string
    ec2_tag_value = string
  }))
  default = []
}

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
variable "timesync_alerts" {
  type = list(object({
    name                  = string
    reference_instance_id = string
  }))
  default = []
}

// New Relic の infrastructure agent を使用
variable "memory_alert_names" {
  type    = list(string)
  default = []
}

variable "alert_network" {
  type = list(object({
    name                     = string
    max_limit_bandwidth_mbps = number
    metrics_interval_minutes = number
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

variable "rds_aurora_alive_alert_names" {
  type    = list(string)
  default = []
}

variable "rds_aurora_replica_lag_alert_names" {
  type    = list(string)
  default = []
}

variable "elasticache_cpu_alert_names" {
  type    = list(string)
  default = []
}

variable "elasticache_swap_alert_names" {
  type    = list(string)
  default = []
}

variable "elasticache_memory_alert_names" {
  type    = list(string)
  default = []
}
