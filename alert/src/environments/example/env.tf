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
      name                      = "[DMM] TopPage (ping)" // Synthetics監視名
      status                    = "ENABLED" // 設定の有効／無効
      uri                       = "https://www.dmm.com/" // 監視対象URL
      validation_string         = "" // 応答で検証する文字列
      verify_ssl                = true // SSL証明書検証の有無
      bypass_head_request       = false // HEAD リクエストをスキップしGETリクエストするかどうか
      treat_redirect_as_failure = false // リダイレクトされた場合に監視を失敗とするかどうか
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
    },
    {
      name                = "[FANZA] TopPage (browser)"
      status              = "ENABLED"
      uri                 = "https://www.dmm.co.jp/"
      validation_string   = "動画"
      verify_ssl          = true
    }
  ]
}
