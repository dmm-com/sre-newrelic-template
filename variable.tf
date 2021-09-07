locals {
  newrelic_synthetics_pings = [
    {
      nr_ping_name                      = "hogeping"
      nr_ping_frequency                 = 2
      nr_ping_uri                       = "https://hogehoge.com"
      nr_ping_validation_string         = "test"
      nr_ping_verify_ssl                = true
      nr_ping_bypass_head_request       = false
      nr_ping_treat_redirect_as_failure = true
    },
    {
      nr_ping_name                      = "hugaping"
      nr_ping_frequency                 = 3
      nr_ping_uri                       = "http://fugafuga.com"
      nr_ping_validation_string         = "test"
      nr_ping_verify_ssl                = false
      nr_ping_bypass_head_request       = false
      nr_ping_treat_redirect_as_failure = false
    }
  ]

  newrelic_synthetics_browser = [
    {
      name                = "hogesynbrowser"
      frequency           = 3
      uri                 = "https://hogehoge.com"
      validation_string   = "test"
      verify_ssl          = true
      bypass_head_request = false
    },
    {
      name                = "fugasynbrowser"
      frequency           = 3
      uri                 = "http://hogehoge.com"
      validation_string   = "test"
      verify_ssl          = false
      bypass_head_request = false
    },
  ]
}
