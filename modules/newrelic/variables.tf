variable "newrelic_synthetics_ping" {
  type = list(object({
    name                      = string
    frequency                 = number
    uri                       = string
    validation_string         = string
    verify_ssl                = bool
    bypass_head_request       = bool
    treat_redirect_as_failure = bool
  }))
}

variable "newrelic_synthetics_browser" {
  type = list(object({
    name                = string
    frequency           = number
    uri                 = string
    validation_string   = string
    verify_ssl          = bool
    bypass_head_request = bool
  }))
}

variable "aws_account_ids" {
  type = list(string)
}

variable "cpu_alert_names" {
  type = list(string)
}

// New Relic の infrastructure agent を使用
variable "alive_alert_names" {
  type = list(string)
}

// New Relic の infrastructure agent を使用
variable "cpuiowait_alert_names" {
  type = list(string)
}

// New Relic の infrastructure agent を使用
variable "disk_alert_names" {
  type = list(object({
    alert_name = string
  }))
}

// New Relic の infrastructure agent を使用
variable "load_average_alert_names" {
  type = list(string)
}

// New Relic の infrastructure agent を使用
variable "timesync_alert_names" {
  type = list(string)
}

// New Relic の infrastructure agent を使用
variable "memory_alert_names" {
  type = list(string)
}

// variable "alert_network" {
//   type = list(object({
//     alert_name = string
//   }))
// }

// New Relic の infrastructure agent を使用
variable "rds_alive_alert_names" {
  type = list(string)
}
