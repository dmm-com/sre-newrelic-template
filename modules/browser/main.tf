variable "nr_browser_name" {
  type = string
}
variable "nr_browser_frequency" {
  type = number
}
variable "nr_browser_uri" {
  type = string
}
variable "nr_browser_validation_string" {
  type = string
}
variable "nr_browser_verify_ssl" {
  type = bool
}
variable "nr_browser_bypass_head_request" {
  type = bool
}

resource "newrelic_synthetics_monitor" "default" {
  type = "BROWSER"

  name                      = var.nr_browser_name
  frequency                 = var.nr_browser_frequency
  uri                       = var.nr_browser_uri
  validation_string         = var.nr_browser_validation_string
  verify_ssl                = var.nr_browser_verify_ssl
  bypass_head_request       = var.nr_browser_bypass_head_request
}