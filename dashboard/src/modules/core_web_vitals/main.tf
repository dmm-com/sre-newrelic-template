// 内容：Core Web Vitalsダッシュボード
//
resource "newrelic_one_dashboard_json" "core_web_vitals" {
  json = templatefile("${path.module}/tftpl/core_web_vitals.json.tftpl", {
    nr_account_id               = var.nr_account_id,
    core_web_vitals_domain_name = var.core_web_vitals_domain_name,
  })
}
