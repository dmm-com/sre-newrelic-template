// 内容：Core Web Vitalsダッシュボード
//
resource "newrelic_one_dashboard" "core_web_vitals" {
  name = "[sample] Core Web Vitals"

  permissions = "public_read_write"

  page {
    name = "Top"

    widget_markdown {
      title = ""
      column = 1
      height = 3
      row    = 1
      width  = 8

      text   = <<-EOT
        # Core Web Vitals
        Core Web Vitals とはGoogleがWebサイトの健全性を示す指標として重視するもので、以下の指標があります。

        ## Largest Contentful Paint（LCP）
        そのページで最も有意義なコンテンツが表示されるまでの時間を表します。（単位：秒）

        ## First Input Delay（FID）
        最初の入力までの遅延時間を表し、ユーザーが最初にページを操作しようとする時の応答性を定量化したものです。（単位：ミリ秒）

        ## Cumulative Layout Shift（CLS）
        ページが視覚的にどの程度安定しているかを表す指標です。（単位：なし）
      EOT
    }

    widget_markdown {
      title = ""
      column = 9
      height = 3
      row    = 1
      width  = 4

      text   = <<-EOT
        参考情報
        - https://web.dev/i18n/ja/vitals/
        - https://digiful.irep.co.jp/blog/48237963801
      EOT
    }

    widget_billboard {
      title  = "LCP（前週比）"
      column = 1
      height = 3
      row    = 4
      width  = 4

      nrql_query {
        account_id = var.nr_account_id
        query      = "SELECT percentile(largestContentfulPaint, 75) FROM PageViewTiming WHERE domain = '${var.core_web_vitals_domain_name}' COMPARE WITH 1 week ago"
      }
    }

    widget_billboard {
      title  = "FID（前週比）"
      column = 5
      height = 3
      row    = 4
      width  = 4

      nrql_query {
        account_id = var.nr_account_id
        query      = "SELECT percentile(firstInputDelay, 75) FROM PageViewTiming WHERE domain = '${var.core_web_vitals_domain_name}' COMPARE WITH 1 week ago"
      }
    }

    widget_billboard {
      title  = "CLS（前週比）"
      column = 9
      height = 3
      row    = 4
      width  = 4

      nrql_query {
        account_id = var.nr_account_id
        query      = "SELECT percentile(cumulativeLayoutShift, 75) FROM PageViewTiming WHERE domain = '${var.core_web_vitals_domain_name}' AND timingName = 'pageHide' COMPARE WITH 1 week ago"
      }
    }

    widget_billboard {
      title  = "デバイス別 LCP（前週比）"
      column = 1
      height = 3
      row    = 7
      width  = 4

      nrql_query {
        account_id = var.nr_account_id
        query      = "SELECT percentile(largestContentfulPaint, 75) FROM PageViewTiming WHERE domain = '${var.core_web_vitals_domain_name}' WHERE deviceType IN ('Mobile', 'Desktop') FACET deviceType COMPARE WITH 1 week ago"
      }
    }

    widget_billboard {
      title  = "デバイス別 FID（前週比）"
      column = 5
      height = 3
      row    = 7
      width  = 4

      nrql_query {
        account_id = var.nr_account_id
        query      = "SELECT percentile(firstInputDelay, 75) FROM PageViewTiming WHERE domain = '${var.core_web_vitals_domain_name}' AND deviceType IN ('Mobile', 'Desktop') FACET deviceType COMPARE WITH 1 week ago"
      }
    }

    widget_billboard {
      title  = "デバイス別 CLS（前週比）"
      column = 9
      height = 3
      row    = 7
      width  = 4

      nrql_query {
        account_id = var.nr_account_id
        query      = "SELECT percentile(cumulativeLayoutShift, 75) FROM PageViewTiming WHERE domain = '${var.core_web_vitals_domain_name}' AND timingName = 'pageHide' AND deviceType IN ('Mobile', 'Desktop') FACET deviceType COMPARE WITH 1 week ago"
      }
    }

    widget_line {
      title  = "デバイス別 LCP（時系列）"
      column = 1
      height = 3
      row    = 10
      width  = 4

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM PageViewTiming SELECT percentile(largestContentfulPaint, 75) WHERE domain = '${var.core_web_vitals_domain_name}' AND deviceType != 'Unknown' FACET deviceType TIMESERIES AUTO"
      }
    }

    widget_line {
      title  = "デバイス別 FID（時系列）"
      column = 5
      height = 3
      row    = 10
      width  = 4

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM PageViewTiming SELECT percentile(firstInputDelay, 75) WHERE domain = '${var.core_web_vitals_domain_name}' AND deviceType != 'Unknown' FACET deviceType TIMESERIES AUTO"
      }
    }

    widget_line {
      title  = "デバイス別 CLS（時系列）"
      column = 9
      height = 3
      row    = 10
      width  = 4

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM PageViewTiming SELECT percentile(cumulativeLayoutShift, 75) WHERE domain = '${var.core_web_vitals_domain_name}' AND deviceType != 'Unknown' FACET deviceType TIMESERIES AUTO"
      }
    }

    widget_billboard {
      title  = "デバイス別 画面のロード時間（LCP）が長いと感じるユーザの割合"
      column = 1
      height = 2
      row    = 13
      width  = 4

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM PageViewTiming SELECT percentage(uniqueCount(session), WHERE largestContentfulPaint >= 4) AS '' WHERE domain = '${var.core_web_vitals_domain_name}' AND deviceType IN ('Mobile', 'Desktop') FACET deviceType"
      }
    }

    widget_billboard {
      title  = "デバイス別 画面の反応性（FID）がよくないと感じているユーザ数の割合"
      column = 5
      height = 2
      row    = 13
      width  = 4

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM PageViewTiming SELECT percentage(uniqueCount(session), WHERE firstInputDelay >= 300) AS '' WHERE domain = '${var.core_web_vitals_domain_name}' AND deviceType IN ('Mobile', 'Desktop') FACET deviceType"
      }
    }

    widget_billboard {
      title  = "デバイス別 視覚的な安定性（CLS）が悪いと感じているユーザ数の割合"
      column = 9
      height = 2
      row    = 13
      width  = 4

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM PageViewTiming SELECT percentage(uniqueCount(session), WHERE cumulativeLayoutShift >= 0.25) AS '' WHERE domain = '${var.core_web_vitals_domain_name}' AND deviceType IN ('Mobile', 'Desktop') FACET deviceType"
      }
    }

    widget_table {
      title                    = "URL別トランザクションサマリ（Desktop）"
      column                   = 1
      height                   = 5
      row                      = 15
      width                    = 12
      linked_entity_guids      = []
      filter_current_dashboard = false

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM PageViewTiming SELECT percentile(firstContentfulPaint, 75), percentile(largestContentfulPaint, 75), percentile(firstInputDelay, 75), max(firstInputDelay), filter(percentile(cumulativeLayoutShift, 75), WHERE timingName = 'firstContentfulPaint') AS 'Cumulative Layout Shift', percentile(pageHide, 75), percentile(windowLoad, 75) WHERE domain = '${var.core_web_vitals_domain_name}' AND deviceType = 'Desktop' FACET browserTransactionName LIMIT 100"
      }
    }

    widget_table {
      title                    = "URL別トランザクションサマリ（Mobile）"
      column                   = 1
      height                   = 5
      row                      = 20
      width                    = 12
      linked_entity_guids      = []
      filter_current_dashboard = false

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM PageViewTiming SELECT percentile(firstContentfulPaint, 75), percentile(largestContentfulPaint, 75), percentile(firstInputDelay, 75), max(firstInputDelay), filter(percentile(cumulativeLayoutShift, 75), WHERE timingName = 'firstContentfulPaint') AS 'Cumulative Layout Shift', percentile(pageHide, 75), percentile(windowLoad, 75) WHERE domain = '${var.core_web_vitals_domain_name}' AND deviceType = 'Mobile' FACET browserTransactionName LIMIT 100"
        }
    }

    widget_table {
      title                    = "顧客満足度の低いページランキング"
      column                   = 1
      height                   = 6
      row                      = 25
      width                    = 12
      linked_entity_guids      = []
      filter_current_dashboard = false
      
      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM (SELECT ceil(clamp_max(clamp_min(percentile(largestContentfulPaint, 75) / 0.75 - 2.3334, 1), 3)) AS 'LCP', ceil(clamp_max(clamp_min(percentile(firstInputDelay, 75) / 100, 1), 3)) AS 'FID', ceil(clamp_max(clamp_min(percentile(cumulativeLayoutShift, 75) / 0.075 - 0.33334, 1), 3)) AS 'CLS', filter(count(*), where eventType() = 'PageView') AS 'PV', filter(average(duration), WHERE eventType() = 'PageView') AS 'Time' FROM PageViewTiming, PageView WHERE domain = '${var.core_web_vitals_domain_name}' FACET targetGroupedUrl LIMIT max) SELECT max(LCP) + max(FID) + max(CLS) AS 'Total', max(LCP) AS 'LCP', max(FID) AS 'FID', max(CLS) AS 'CLS', max(PV) AS 'PV', max(Time) AS 'Time(sec)' WHERE LCP > 1 OR FID > 1 OR CLS > 1 FACET targetGroupedUrl LIMIT 50"
        }
    }
  }
}
