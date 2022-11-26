# Alert to email
resource "newrelic_notification_destination" "email" {
  count = var.create_email_notification ? 1 : 0

  account_id = var.nr_account_id

  name = var.email_destination_name
  type = "EMAIL"

  property {
    key   = "email"
    value = var.email_destination_address
  }
}

resource "newrelic_notification_channel" "email" {
  count = var.create_email_notification ? 1 : 0

  account_id = var.nr_account_id

  name = "EmailTo-${var.email_destination_address}"
  type = "EMAIL"

  destination_id = newrelic_notification_destination.email[count.index].id

  product = "IINT"

  property {
    key   = "subject"
    value = "{{ issueTitle }}"
  }
}

resource "newrelic_workflow" "comprehensive_alerts_to_email" {
  count = var.create_email_notification ? 1 : 0

  enabled = true

  account_id = var.nr_account_id

  name = "${var.workflow_name}-to-email"

  muting_rules_handling = "DONT_NOTIFY_FULLY_MUTED_ISSUES"

  issues_filter {
    name = "labels-policyIds"
    type = "FILTER"

    predicate {
      attribute = "labels.policyIds"
      operator  = "EXACTLY_MATCHES"
      values = [
        "${var.policy_id}"
      ]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.email[count.index].id
  }
}

# Alert to slack
resource "newrelic_notification_channel" "slack" {
  count = var.create_slack_notification ? 1 : 0

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

resource "newrelic_workflow" "comprehensive_alerts_to_slack" {
  count = var.create_slack_notification ? 1 : 0

  enabled = true

  account_id = var.nr_account_id

  name = "${var.workflow_name}-to-slack"

  muting_rules_handling = "DONT_NOTIFY_FULLY_MUTED_ISSUES"

  issues_filter {
    name = "labels-policyIds"
    type = "FILTER"

    predicate {
      attribute = "labels.policyIds"
      operator  = "EXACTLY_MATCHES"
      values = [
        "${var.policy_id}"
      ]
    }
  }

  destination {
    channel_id = newrelic_notification_channel.slack[count.index].id
  }
}
