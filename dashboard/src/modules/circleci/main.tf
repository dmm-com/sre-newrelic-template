// 内容：CircleCIインテグレーションダッシュボード
//
resource "newrelic_one_dashboard_json" "circleci" {
  json = templatefile("${path.module}/tftpl/circleci.json.tftpl", {
    nr_account_id              = var.nr_account_id,
    circleci_organization_name = var.circleci_organization_name,
  })
}
