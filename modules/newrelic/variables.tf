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

variable "newrelic_alert_cpu" {
  type = list(object({
    name        = string
    ec2tag_name = list(string)
  }))
}

variable "newrelic_infra_agent_alert_alive" {
  type = list(object({
    alert_name     = string
    aws_account_id = list(string)
  }))
}

variable "newrelic_infra_agent_alert_cpu_iowait" {
  type = list(object({
    alert_name     = string
    aws_account_id = list(string)
  }))
}

variable "newrelic_infra_agent_alert_disk" {
  type = list(object({
    alert_name     = string
    aws_account_id = list(string)
  }))
}

variable "newrelic_infra_agent_alert_load_average" {
  type = list(object({
    alert_name     = string
    aws_account_id = list(string)
  }))
}

variable "newrelic_infra_agent_alert_timesync" {
  type = list(object({
    alert_name     = string
    aws_account_id = list(string)
  }))
}
