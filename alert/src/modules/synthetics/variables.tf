variable "policy_id" {
  type = string
}

variable "slack_mention" {
  type = string
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
