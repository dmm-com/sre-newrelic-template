locals {
  nr_account_id = 1234567                            // NewRelicアカウントID, 数値型
  nr_api_key    = "NRAK-xxxxxxxxxxxxxxxxxxxxxxxxxxx" // Type:USERのAPIキー, 文字列型

  // aws_newrelic_charge
  exchange_rate = "140" // 為替レート, 文字列型

  // core_web_vitals
  core_web_vitals_domain_name = "www.dmm.co.jp" // Core Web Vitalsのチェック対象とするドメイン名, 文字列型

  // circleci
  circleci_organization_name = "book" // CircleCIのオーガニゼーション名, 文字列型
}
