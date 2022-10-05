resource "newrelic_notification_destination" "email" {
  account_id = var.nr_account_id

  name = var.email_notification_destination
  type = "EMAIL"

  property {
    key   = "email"
    value = var.email_notification_destination
  }
}

resource "newrelic_notification_channel" "email" {
  account_id = var.nr_account_id

  name = "EmailTo-${var.email_notification_destination}"
  type = "EMAIL"

  destination_id = newrelic_notification_destination.email.id

  product = "IINT"

  property {
    key   = "subject"
    value = "{{ issueTitle }}"
  }
}

resource "newrelic_notification_channel" "slack" {
  account_id = var.nr_account_id

  name = "SlackTo-tsuchinoko"
  type = "SLACK"

  destination_id = var.slack_destination_id

  product = "IINT"

  property {
    display_value = var.slack_channel_name
    key           = "channelId"
    value         = var.slack_channel_id
  }
}

resource "newrelic_workflow" "comprehensive_alerts_to_email" {
  enabled = true

  account_id = var.nr_account_id

  name = "${var.workflow_name}-to-email"

  muting_rules_handling = "DONT_NOTIFY_FULLY_MUTED_ISSUES"

  issues_filter {
    name = "labels-policyIds"
    type = "FILTER"

    predicate {
      attribute = "labels.policyIds"
      operator = "EXACTLY_MATCHES"
      values = [
        "${var.policy_id}"
      ]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.email.id
  }
}

resource "newrelic_workflow" "comprehensive_alerts_to_slack" {
  enabled = true

  account_id = var.nr_account_id

  name = "${var.workflow_name}-to-slack"

  muting_rules_handling = "DONT_NOTIFY_FULLY_MUTED_ISSUES"

  issues_filter {
    name = "labels-policyIds"
    type = "FILTER"

    predicate {
      attribute = "labels.policyIds"
      operator = "EXACTLY_MATCHES"
      values = [
        "${var.policy_id}"
      ]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.slack.id
  }
}
