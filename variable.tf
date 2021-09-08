locals {
  newrelic_synthetics_pings = [
    {
      name                      = "hogeping"
      frequency                 = 2
      uri                       = "https://hogehoge.com"
      validation_string         = "test"
      verify_ssl                = true
      bypass_head_request       = false
      treat_redirect_as_failure = true
    },
    {
      name                      = "hugaping"
      frequency                 = 3
      uri                       = "http://fugafuga.com"
      validation_string         = "test"
      verify_ssl                = false
      bypass_head_request       = false
      treat_redirect_as_failure = false
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

  // todo: 空配列を渡した場合、動かさないように
  newrelic_alive_alert = [
    {
      name        = "hoge"
      ec2tag_name = "hogetag"
    },
    {

    }
  ]
  newrelic_cpu_alert_ec2tags        = []
  newrelic_cpu_iowait_alert_ec2tags = []
}
