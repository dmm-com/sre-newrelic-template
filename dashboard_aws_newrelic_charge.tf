// 内容：AWSとNewRelicの料金ダッシュボード
//
resource "newrelic_one_dashboard" "aws_newrelic_charge" {
  name = "[sample] 料金"

  permissions = "public_read_write"

  page {
    name = "AWS"

    widget_markdown {
      title = ""
      column = 1
      height = 6
      row    = 1
      width  = 2

      text   = <<-EOT
        AWSアカウントIDと対応サービス
        ---

        ```
        405130845841 [dj-stg-aws] : ステージング環境
        102755423074 [dj-prod-p-aws] : 本番環境
        ```

        備考
        - 日本円への変換は、1ドル120円換算としています。
        - AWS料金は月初のUTC0時にリセットされます。
        - AWS料金は割引適用前料金のため、実際の請求金額と異なります。
      EOT
    }

    widget_table {
      title                    = "月初から現在までのAWS料金"
      column                   = 3
      height                   = 3
      row                      = 1
      width                    = 5
      linked_entity_guids      = []
      filter_current_dashboard = false

      nrql_query {
        account_id = var.nr_account_id
        query      = "SELECT round(latest(`provider.estimatedCharges.Maximum`) * 120) AS '料金（円）' FROM FinanceSample WHERE provider = 'BillingAccountCost' FACET providerAccountName SINCE 1 day ago"
      }
    }

    widget_area {
      title  = "AWS料金推移（円）"
      column = 3
      height = 3
      row    = 4
      width  = 5

      nrql_query {
        account_id = var.nr_account_id
        query      = "SELECT round(latest(`provider.estimatedCharges.Maximum`) * 120) FROM FinanceSample WHERE provider = 'BillingAccountCost' FACET providerAccountName TIMESERIES AUTO SINCE 1 month ago"
      }
    }

    widget_bar {
      title                    = "月初から現在までのサービス別AWS料金（円）"
      column                   = 8
      height                   = 6
      row                      = 1
      width                    = 5
      linked_entity_guids      = []
      filter_current_dashboard = false

      nrql_query {
        account_id = var.nr_account_id
        query      = "SELECT round(latest(`provider.estimatedCharges.Maximum`) * 120) FROM FinanceSample WHERE provider = 'BillingServiceCost' FACET `provider.serviceName` SINCE 1 day ago LIMIT 100"
      }
    }
  }

  page {
    name = "NewRelic"

    widget_stacked_bar {
      title  = "1日あたりのデータ使用量（GB）"
      column = 1
      height = 3
      row    = 1
      width  = 6

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM NrConsumption SELECT sum(GigabytesIngested) WHERE productLine = 'DataPlatform' TIMESERIES 1 day SINCE 3 months ago"
      }
    }

    widget_stacked_bar {
      title  = "1日あたりのデータ使用量（GB）"
      column = 7
      height = 3
      row    = 1
      width  = 6

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM NrMTDConsumption SELECT latest(GigabytesIngested) WHERE productLine = 'DataPlatform' FACET month TIMESERIES AUTO SINCE 3 months ago"
      }
    }

    widget_stacked_bar {
      title  = "1日あたりのデータ使用料金（円）"
      column = 1
      height = 3
      row    = 4
      width  = 6

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM NrConsumption SELECT sum(GigabytesIngested) * 0.25 * 120 WHERE productLine = 'DataPlatform' TIMESERIES 1 day SINCE 3 months ago"
      }
    }

    widget_stacked_bar {
      title  = "1日あたりのソース別データ使用量（GB）"
      column = 7
      height = 3
      row    = 4
      width  = 6

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM NrConsumption SELECT sum(GigabytesIngested) WHERE productLine = 'DataPlatform' FACET usageMetric TIMESERIES 1 day SINCE 3 months ago"
      }
    }
  }
}
