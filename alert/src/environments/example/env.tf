locals {
  alert_policy_name = "" // アラートポリシー名
  alert_slack_channel = {
    name    = "" // NewRelicチャンネル設定名
    url     = "" // Slack Incoming Webhook URL
    channel = "" // Slackチャンネル名
  }
  slack_mention = "" // Slack通知時のメンション先

  apm_app_name_prefix = "" // NewRelic APMの監視対象とするappNameの接頭辞
}
