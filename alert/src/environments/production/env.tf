locals {
  alert_policy_name = "" // アラートポリシー名
  alert_slack_channel = {
    name    = "" // NewRelicチャンネル設定名
    url     = "" // Slack Webhook URL
    channel = "" // Slackチャンネル名
  }
  slack_mention = "" // Slack通知時のメンション先

  apm_app_name_prefix = "" // NewRelic APMの監視対象とするappNameの接頭辞

  newrelic_synthetics_ping = [
    {
      name                      = "" // Synthetics監視名
      status                    = "" // 設定の有効／無効
      uri                       = "" // 監視対象URL
      validation_string         = "" // 応答で検証する文字列
      verify_ssl                =  // SSL証明書検証の有無
      bypass_head_request       =  // HEAD リクエストをスキップしGETリクエストするかどうか
      treat_redirect_as_failure =  // リダイレクトされた場合に監視を失敗とするかどうか
    },
    {
      name                      = ""
      status                    = ""
      uri                       = ""
      validation_string         = ""
      verify_ssl                = 
      bypass_head_request       = 
      treat_redirect_as_failure = 
    }
  ]

  newrelic_synthetics_browser = [
    {
      name              = ""
      status            = ""
      uri               = ""
      validation_string = ""
      verify_ssl        = 
    },
    {
      name              = ""
      status            = ""
      uri               = ""
      validation_string = ""
      verify_ssl        = 
    }
  ]
}
