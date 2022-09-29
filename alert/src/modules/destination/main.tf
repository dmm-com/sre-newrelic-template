resource "newrelic_notification_destination" "email" {
  account_id = var.nr_account_id

  name = var.email_notification_destination
  type = "EMAIL"

  property {
    key   = "email"
    value = var.email_notification_destination
  }
}
