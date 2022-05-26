locals {
  aws_region = "ap-northeast-1"

  nr_account_id  =  // 数値型
  nr_external_id = 
  nr_api_key     = "" // Type:USERのAPIキー

  alert_policy_name   = "prodAlert"
  alert_slack_channel = {
    name    = "prodAlertSlack"
    url     = "" // slack hook url
    channel = "" // Team Channel用
  }
  slack_mention       = ""
}
