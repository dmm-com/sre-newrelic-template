locals {
  alert_policy_name = "SampleAlert" // アラートポリシー名
  alert_slack_channel = {
    name    = "SampleAlertSlack" // NewRelicチャンネル設定名
    url     = "" // Slack Webhook URL
    channel = "" // Slackチャンネル名
  }
  slack_mention = "" // Slack通知時のメンション先

  apm_app_name_prefix = "[sample]%" // NewRelic APMの監視対象とするappNameの接頭辞
}
