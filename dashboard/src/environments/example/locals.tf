locals {
  nr_account_id  =  // NewRelicアカウントID, 数値型
  nr_license_key = "" // Type:USERのAPIキー

  // aws_newrelic_charge
  exchange_rate = "120" // 為替レート

  // core_web_vitals
  core_web_vitals_domain_name = "www.dmm.co.jp" // Core Web Vitalsのチェック対象とするドメイン名

  // circleci
  circleci_organization_name = "book" // CircleCIのオーガニゼーション名
}
