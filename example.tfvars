nr_account_id = 123456789        // 変更する
nr_api_key    = "testkeytestkey" // 変更する

aws_account_id = "987654321" // 変更する

// -------------------------------------------
// Synthetics
// -------------------------------------------
newrelic_synthetics_ping = [
  {
    name                      = "hogeping"
    status                    = "ENABLED"
    uri                       = "https://hogehoge.com"
    validation_string         = "test"
    verify_ssl                = true
    bypass_head_request       = false
    treat_redirect_as_failure = true
  },
  {
    name                      = "hugaping"
    status                    = "ENABLED"
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
    status              = "ENABLED"
    uri                 = "https://hogehoge.com"
    validation_string   = "test"
    verify_ssl          = true
    bypass_head_request = false
  },
  {
    name                = "fugasynbrowser"
    status              = "ENABLED"
    uri                 = "http://hogehoge.com"
    validation_string   = "test"
    verify_ssl          = false
    bypass_head_request = false
  },
]

// -------------------------------------------
// Alart
// -------------------------------------------

alert_slack_channel = [{
  name    = "hoge"
  url     = "https://hooks.slack.com/services/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"
  channel = "newrelic-alert-test"
}]

// EC2 alert
cpu_alerts               = []
alive_alert_names        = []
cpuiowait_alert_names    = []
disk_alert_names         = []
load_average_alert_names = []
timesync_alert_names     = []
memory_alert_names       = []
alert_network            = []

// RDS alert
rds_alive_alert_names       = []
rds_replica_lag_alert_names = []
rds_connection_alert_names  = []
