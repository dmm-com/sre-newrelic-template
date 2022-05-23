// 内容：SyntheticsのPing監視
//
resource "newrelic_synthetics_monitor" "synthetics_ping" {
  count = length(var.newrelic_synthetics_ping)

  name      = var.newrelic_synthetics_ping[count.index].name
  type      = "SIMPLE"
  frequency = 1
  locations = ["AWS_AP_NORTHEAST_1", "AWS_US_WEST_1", "AWS_US_EAST_1"]
  status    = var.newrelic_synthetics_ping[count.index].status

  uri                       = var.newrelic_synthetics_ping[count.index].uri
  validation_string         = var.newrelic_synthetics_ping[count.index].validation_string
  verify_ssl                = var.newrelic_synthetics_ping[count.index].verify_ssl
  bypass_head_request       = var.newrelic_synthetics_ping[count.index].bypass_head_request
  treat_redirect_as_failure = var.newrelic_synthetics_ping[count.index].treat_redirect_as_failure
}

// 内容：SyntheticsのSimple Browser監視
//
resource "newrelic_synthetics_monitor" "synthetics_browser" {
  count = length(var.newrelic_synthetics_browser)

  name      = var.newrelic_synthetics_browser[count.index].name
  type      = "BROWSER"
  frequency = 1
  locations = ["AWS_AP_NORTHEAST_1", "AWS_US_WEST_1", "AWS_US_EAST_1"]
  status    = var.newrelic_synthetics_browser[count.index].status

  uri                 = var.newrelic_synthetics_browser[count.index].uri
  validation_string   = var.newrelic_synthetics_browser[count.index].validation_string
  verify_ssl          = var.newrelic_synthetics_browser[count.index].verify_ssl
  bypass_head_request = var.newrelic_synthetics_browser[count.index].bypass_head_request
}
