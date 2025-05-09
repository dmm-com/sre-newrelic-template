locals {
  alert_policy_name = "SampleAlert" // アラートポリシー名

  create_email_notification = "false" // E-Mail通知をするか否か "true" or "false"
  create_slack_notification = "true"  // Slack通知をするか否か "true" or "false"

  alert_to_email = {
    destination_name    = "Notify to Email"     // 通知先名
    destination_address = "sample-user@dmm.com" // 通知先メールアドレス（複数指定可 "xxx@dmm.com,yyy@dmm.com,zzz@dmm.com"）
  }

  alert_to_slack = {
    destination_id = "b1a45e2a-f3bb-48c2-9a0b-beea8761dfd8" // [Alerts] - [Destinations] - [Destinations]にあるSlack連携後に付与されるdestination id（作成されたSlack設定右側にある三点リーダーから Copy destination id to clipboard でコピー可能）
    channel_name   = "newrelic-template-sandbox"            // Slackチャンネル名
    channel_id     = "C072PSCRFEW"                          // SlackチャンネルID
  }

  slack_mention = "!here" // Slack通知時のメンション先 e.g. !channel, !here, @yamada-taro

  apm_app_name_prefix = "[sample]%" // NewRelic APMの監視対象とするappNameの接頭辞

  newrelic_synthetics_ping = [
    {
      name                      = "[DMM] TopPage (Ping)" // Synthetics監視名
      status                    = "ENABLED"              // 設定の有効／無効
      uri                       = "https://www.dmm.com/" // 監視対象URL
      validation_string         = ""                     // 応答で検証する文字列
      verify_ssl                = true                   // SSL証明書検証の有無
      bypass_head_request       = false                  // HEAD リクエストをスキップしGETリクエストするかどうか
      treat_redirect_as_failure = false                  // リダイレクトされた場合に監視を失敗とするかどうか
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
      name              = "[DMM] TopPage (Simple Browser)"
      status            = "ENABLED"
      uri               = "https://www.dmm.com/"
      validation_string = "電子書籍"
      verify_ssl        = true
    },
    {
      name              = "[FANZA] TopPage (browser)"
      status            = "ENABLED"
      uri               = "https://www.dmm.co.jp/"
      validation_string = "動画"
      verify_ssl        = true
    }
  ]
}
