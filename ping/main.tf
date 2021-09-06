variable "nr_ping_name" {
  type = string
}
variable "nr_ping_frequency" {
  type = number
}
variable "nr_ping_uri" {
  type = string
}
variable "nr_ping_validation_string" {
  type = string
}
variable "nr_ping_verify_ssl" {
  type = bool
}
variable "nr_ping_bypass_head_request" {
  type = bool
}
variable "nr_ping_treat_redirect_as_failure" {
  type = bool
}

resource "newrelic_synthetics_monitor" "default" {
  type = "SIMPLE"

  name                      = var.nr_ping_name
  frequency                 = var.nr_ping_frequency
  uri                       = var.nr_ping_uri
  validation_string         = var.nr_ping_validation_string
  verify_ssl                = var.nr_ping_verify_ssl
  bypass_head_request       = var.nr_ping_bypass_head_request
  treat_redirect_as_failure = var.nr_ping_treat_redirect_as_failure
}
