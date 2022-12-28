// 内容：AWSとNewRelicの料金ダッシュボード
//
resource "newrelic_one_dashboard_json" "aws_newrelic_charge" {
  json = templatefile("${path.module}/tftpl/aws_newrelic_charge.json.tftpl", {
    nr_account_id = var.nr_account_id,
    exchange_rate = var.exchange_rate,
  })
}
