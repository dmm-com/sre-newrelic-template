resource "newrelic_alert_policy" "policy" {
  name = var.alert_policy_name
}

resource "newrelic_alert_channel" "channel" {
  type = "slack"
  name = var.alert_slack_channel.name

  config {
    url     = var.alert_slack_channel.url
    channel = var.alert_slack_channel.channel
  }
}

resource "newrelic_alert_policy_channel" "slack_channel" {
  policy_id   = newrelic_alert_policy.policy.id
  channel_ids = [newrelic_alert_channel.channel.id]
}
