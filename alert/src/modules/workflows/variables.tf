variable "nr_account_id" {
  type = number
}

variable "create_email_notification" {
  type = bool
}

variable "create_slack_notification" {
  type = bool
}

variable "email_destination_name" {
  type = string
}

variable "email_destination_address" {
  type = string
}

variable "slack_destination_id" {
  type = string
}

variable "slack_channel_name" {
  type = string
}

variable "slack_channel_id" {
  type = string
}

variable "workflow_name" {
  type = string
}

variable "policy_id" {
  type = string
}
