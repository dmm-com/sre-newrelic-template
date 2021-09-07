resource "newrelic_synthetics_monitor" "default" {
  count = length(local.newrelic_synthetics_pings)

  type                      = "SIMPLE"
  name                      = local.nr_ping_name[count.index]
  frequency                 = local.nr_ping_frequency[count.index]
  uri                       = local.nr_ping_uri[count.index]
  validation_string         = local.nr_ping_validation_string[count.index]
  verify_ssl                = local.nr_ping_verify_ssl[count.index]
  bypass_head_request       = local.nr_ping_bypass_head_request[count.index]
  treat_redirect_as_failure = local.nr_ping_treat_redirect_as_failure[count.index]
}

resource "newrelic_synthetics_monitor" "default" {
  count = length(local.newrelic_synthetics_browser)

  type = "BROWSER"
  name                = local.nr_syn_browser_name[count.index]
  frequency           = local.nr_syn_browser_frequency[count.index]
  uri                 = local.nr_syn_browser_uri[count.index]
  validation_string   = local.nr_syn_browser_validation_string[count.index]
  verify_ssl          = local.nr_syn_browser_verify_ssl[count.index]
  bypass_head_request = local.nr_syn_browser_bypass_head_request[count.index]
}
