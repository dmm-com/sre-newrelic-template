locals {
  nr_account_id = 1234567 // NewRelicアカウントID, 数値型
  nr_api_key    = ""      // Type:USERのAPIキー

  // aws_newrelic_charge
  exchange_rate = "" // 為替レート

  // core_web_vitals
  core_web_vitals_domain_name = "" // Core Web Vitalsのチェック対象とするドメイン名

  // circleci
  circleci_organization_name = "" // CircleCIのオーガニゼーション名
}
