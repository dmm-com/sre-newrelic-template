locals {
  alert_policy_name = "" // アラートポリシー名
  alert_slack_channel = {
    name    = "" // NewRelicチャンネル設定名
    url     = "" // Slack Webhook URL
    channel = "" // Slackチャンネル名
  }
  slack_mention = "" // Slack通知時のメンション先 e.g. !here , @yamada-taro

  apm_app_name_prefix = "" // NewRelic APMの監視対象とするappNameの接頭辞

  newrelic_synthetics_ping = [
    {
      name                      = "" // Synthetics監視名
      status                    = "" // 設定の有効／無効
      uri                       = "" // 監視対象URL
      validation_string         = "" // 応答で検証する文字列
      verify_ssl                = true // SSL証明書検証の有無
      bypass_head_request       = false // HEAD リクエストをスキップしGETリクエストするかどうか
      treat_redirect_as_failure = false // リダイレクトされた場合に監視を失敗とするかどうか
    },
    {
      name                      = ""
      status                    = ""
      uri                       = ""
      validation_string         = ""
      verify_ssl                = true
      bypass_head_request       = false
      treat_redirect_as_failure = false
    }
  ]

  newrelic_synthetics_browser = [
    {
      name              = ""
      status            = ""
      uri               = ""
      validation_string = ""
      verify_ssl        = true
    },
    {
      name              = ""
      status            = ""
      uri               = ""
      validation_string = ""
      verify_ssl        = true
    }
  ]
}
