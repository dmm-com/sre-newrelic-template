locals {
  alert_policy_name = "" // アラートポリシー名

  create_email_notification = "true" // E-Mail通知をするか否か "true" or "false"
  create_slack_notification = "true" // Slack通知をするか否か "true" or "false"

  alert_to_email = {
    destination_name    = "" // 通知先名
    destination_address = "" // 通知先メールアドレス（複数指定可 "xxx@dmm.com,yyy@dmm.com,zzz@dmm.com"）
  }

  alert_to_slack = {
    destination_id = "" // [Alerts & AI] - [Destinations] - [Destinations]にあるSlack連携後に付与されるdestination id（作成されたSlack設定右側にある三点リーダーから Copy destination id to clipboard でコピー可能）
    channel_name   = "" // Slackチャンネル名
    channel_id     = "" // Slack ID
  }

  slack_mention = "" // Slack通知時のメンション先 e.g. !here , @yamada-taro

  # 以下はサンプル設定です。適宜修正してください。
  apm_app_name_prefix = "[sample]%" // NewRelic APMの監視対象とするappNameの接頭辞

  # 以下はサンプル設定です。適宜修正してください。
  newrelic_synthetics_ping = [
    {
      name                      = "[DMM] TopPage (Ping)" // Synthetics監視名
      status                    = "ENABLED"              // 設定の有効／無効
      uri                       = "https://www.dmm.com/" // 監視対象URL
      validation_string         = ""                     // 応答で検証する文字列
      verify_ssl                = true                   // SSL証明書検証の有無
      bypass_head_request       = false                  // HEAD リクエストをスキップしGETリクエストするかどうか
      treat_redirect_as_failure = false                  // リダイレクトされた場合に監視を失敗とするかどうか
    }
  ]

  # 以下はサンプル設定です。適宜修正してください。
  newrelic_synthetics_browser = [
    {
      name              = "[DMM] TopPage (Simple Browser)"
      status            = "ENABLED"
      uri               = "https://www.dmm.com/"
      validation_string = "電子書籍"
      verify_ssl        = true
    }
  ]
}
