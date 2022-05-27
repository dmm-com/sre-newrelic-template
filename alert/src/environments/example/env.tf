locals {
  alert_policy_name = "" // アラートポリシー名
  alert_slack_channel = {
    name    = ""
    url     = "" // Slack Incoming Webhook URL
    channel = "" // チャンネル名
  }
  slack_mention = "" // Slack通知時のメンション先

  apm_app_name_prefix = "" // NewRelic APMの監視対象とするappNameの接頭辞
}
