variable "alert_policy_name" {
  type = string
}

variable "alert_slack_channel" {
  type = object({
    name    = string
    url     = string
    channel = string
  })
}

variable "slack_mention" {
  type = string
}
