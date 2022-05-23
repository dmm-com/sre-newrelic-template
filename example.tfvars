nr_account_id  = // 数値型
nr_api_key     = "" // Type:USERのAPIキー
nr_external_id = // 数値型

aws_region     = "ap-northeast-1"
aws_access_key = ""
aws_secret_key = ""

slack_mention = ""

// APM alerts
apm_app_name_prefix = ""

// -------------------------------------------
// Synthetics
// -------------------------------------------
newrelic_synthetics_ping = [
  {
    name                      = "[DMM] TopPage"
    status                    = "ENABLED"
    uri                       = "https://dmm.com/"
    validation_string         = "" // レスポンスが正しいかチェックする時用のバリデーション文字列
    verify_ssl                = true
    bypass_head_request       = false // pingチェックのときデフォルトのHEADリクエストをスキップし、代わりにGETリクエストを使用する
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
    name                = "TopPage"
    status              = "ENABLED"
    uri                 = "https://www.dmm.com"
    validation_string   = "Welcome to DMM.com!"
    verify_ssl          = true
    bypass_head_request = false
  },
  {
    name                = "fugasynbrowser"
    status              = "ENABLED"
    uri                 = "http://fugafuga.com"
    validation_string   = "test"
    verify_ssl          = false
    bypass_head_request = false
  }
]

// -------------------------------------------
// Alart
// -------------------------------------------
alert_policy_name = "prodAlert"

alert_slack_channel = {
  name    = "prodAlertSlack"
  url     = "" // slack hook url
  channel = "" // Team Channel用
}

// EC2 alerts
ec2_network_bandwidth_used_percent_alerts = [{
  max_limit_bandwidth_mbps = 1000 // 監視対象インスタンスの帯域上限 この場合は 1000mbps
  metrics_interval_minutes = 1    // 拡張メトリクス監視(1分間隔)を使用する場合は 1, それ以外の場合は5分間隔なので 5
}]
