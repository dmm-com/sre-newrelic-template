resource "newrelic_synthetics_monitor" "ping" {
  count     = length(var.newrelic_synthetics_ping)
  locations = ["AWS_AP-NORTHEAST-1", "AWS_US_WEST_1", "AWS_US_EAST_1"]
  frequency = 1

  type                      = "SIMPLE"
  name                      = var.newrelic_synthetics_ping[count.index].name
  status                    = var.newrelic_synthetics_ping[count.index].status
  uri                       = var.newrelic_synthetics_ping[count.index].uri
  validation_string         = var.newrelic_synthetics_ping[count.index].validation_string
  verify_ssl                = var.newrelic_synthetics_ping[count.index].verify_ssl
  bypass_head_request       = var.newrelic_synthetics_ping[count.index].bypass_head_request
  treat_redirect_as_failure = var.newrelic_synthetics_ping[count.index].treat_redirect_as_failure
}

resource "newrelic_synthetics_monitor" "syn_browser" {
  count     = length(var.newrelic_synthetics_browser)
  locations = ["AWS_AP-NORTHEAST-1", "AWS_US_WEST_1", "AWS_US_EAST_1"]
  frequency = 1

  type                = "BROWSER"
  name                = var.newrelic_synthetics_browser[count.index].name
  status              = var.newrelic_synthetics_browser[count.index].status
  uri                 = var.newrelic_synthetics_browser[count.index].uri
  validation_string   = var.newrelic_synthetics_browser[count.index].validation_string
  verify_ssl          = var.newrelic_synthetics_browser[count.index].verify_ssl
  bypass_head_request = var.newrelic_synthetics_browser[count.index].bypass_head_request
}
