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

  name = "email-example"
  type = "EMAIL"

  destination_id = newrelic_notification_destination.email.id

  product = "IINT"

  property {
    key   = "subject"
    value = "{{ issueTitle }}"
  }
}
