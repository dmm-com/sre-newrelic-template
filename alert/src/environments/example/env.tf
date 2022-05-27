locals {
  alert_policy_name = "SampleAlert" // アラートポリシー名
  alert_slack_channel = {
    name    = "SampleAlertSlack" // NewRelicチャンネル設定名
    url     = "" // Slack Webhook URL
    channel = "" // Slackチャンネル名
  }
  slack_mention = "" // Slack通知時のメンション先

  apm_app_name_prefix = "[sample]%" // NewRelic APMの監視対象とするappNameの接頭辞

  newrelic_synthetics_ping = [
    {
      name                      = "[DMM] TopPage (ping)"
      status                    = "ENABLED"
      uri                       = "https://www.dmm.com/"
      validation_string         = "" // レスポンスが正しいかチェックする時用のバリデーション文字列
      verify_ssl                = true
      bypass_head_request       = false // pingチェックのときデフォルトのHEADリクエストをスキップし、代わりにGETリクエストを使用する
      treat_redirect_as_failure = false
    },
    {
      name                      = "[FANZA] TopPage (ping)"
      status                    = "ENABLED"
      uri                       = "https://www.dmm.co.jp/"
      validation_string         = "動画"
      verify_ssl                = true
      bypass_head_request       = false
      treat_redirect_as_failure = false
    }
  ]

  newrelic_synthetics_browser = [
    {
      name                = "[DMM] TopPage (browser)"
      status              = "ENABLED"
      uri                 = "https://www.dmm.com/"
      validation_string   = "電子書籍"
      verify_ssl          = true
      bypass_head_request = false
    },
    {
      name                = "[FANZA] TopPage (browser)"
      status              = "ENABLED"
      uri                 = "https://www.dmm.co.jp/"
      validation_string   = "動画"
      verify_ssl          = true
      bypass_head_request = false
    }
  ]
}
