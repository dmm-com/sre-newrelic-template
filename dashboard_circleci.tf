// 内容：CircleCIインテグレーションダッシュボード
//
resource "newrelic_one_dashboard" "circleci" {
  name = "[sample] CircleCI"

  permissions = "public_read_write"

  page {
    name = "Top"

    widget_area {
      title  = "Workflows Per Day"
      column = 5
      height = 3
      row    = 4
      width  = 4

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM Log SELECT uniqueCount(workflow.id) WHERE type = 'workflow-completed' FACET project.name TIMESERIES 1 days since 30 days ago"
      }
    }

    widget_area {
      title  = "日毎の成功デプロイ総数"
      column = 3
      height = 3
      row    = 13
      width  = 4

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM Log SELECT uniqueCount(workflow.id) WHERE workflow.status = 'success' TIMESERIES 1 day FACET project.name SINCE 30 days ago"
      }
    }

    widget_bar {
      title                    = "Jobs Ran Per Project"
      column                   = 5
      height                   = 3
      row                      = 1
      width                    = 4
      linked_entity_guids      = []
      filter_current_dashboard = false

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM Log SELECT Count(job.id) facet project.name as 'Project' since 30 days ago"
      }
    }

    widget_billboard {
      title  = "Total Workflows"
      column = 1
      height = 3
      row    = 4
      width  = 1

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM Log SELECT uniqueCount(workflow.id) AS 'Workflows Ran' WHERE type = 'workflow-completed' since 30 days ago"
      }
    }

    widget_billboard {
      title  = "Total Jobs"
      column = 1
      height = 3
      row    = 7
      width  = 1

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM Log SELECT count(job.id) as 'Jobs Ran' since 30 days ago"
      }
    }

    widget_billboard {
      title  = "今週の成功デプロイ総数（先週比較）"
      column = 1
      height = 3
      row    = 13
      width  = 2

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM Log SELECT uniqueCount(workflow.id) AS 'Deploys' WHERE workflow.status = 'success' SINCE this week COMPARE WITH 1 week ago"
      }
    }

    widget_line {
      title  = "Daily Performance"
      column = 9
      height = 4
      row    = 6
      width  = 4

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM Log SELECT count(job.id) facet job.status TIMESERIES 1 days since 30 days ago"
      }
    }

    widget_line {
      title  = "Jobs Per Day"
      column = 5
      height = 3
      row    = 7
      width  = 4

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM Log SELECT count(job.id) facet project.name TIMESERIES 1 days since 30 days ago"
      }
    }

    widget_pie {
      title                    = "Workflow Health"
      column                   = 2
      height                   = 3
      row                      = 4
      width                    = 3
      linked_entity_guids      = []
      filter_current_dashboard = false

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM Log SELECT uniqueCount(workflow.id) WHERE type = 'workflow-completed' FACET workflow.status since 30 days ago"
      }
    }

    widget_pie {
      title                    = "Job Health"
      column                   = 2
      height                   = 3
      row                      = 7
      width                    = 3
      linked_entity_guids      = []
      filter_current_dashboard = false

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM Log SELECT count(job.id) as 'Jobs' facet job.status since 30 days ago"
      }
    }

    widget_table {
      title                    = "Summary"
      column                   = 1
      height                   = 3
      row                      = 1
      width                    = 4
      linked_entity_guids      = []
      filter_current_dashboard = false

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM Log SELECT count(cases(where job.status = 'success')) as 'Success', count(cases(where job.status='failed')) as 'Failed', percentage(count(job.id), WHERE job.status = 'success') as 'Health' Facet project.name as 'Project' since 30 days ago "
      }
    }

    widget_table {
      title                    = "Recent Job Duration"
      column                   = 9
      height                   = 5
      row                      = 1
      width                    = 4
      linked_entity_guids      = []
      filter_current_dashboard = false

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM Log SELECT job.name as 'Job Name', job.started_at as 'Started Time', job.stopped_at as 'Stopped Time', timestamp WHERE job.started_at IS NOT NULL since 3 days ago limit 10"
      }
    }

    widget_table {
      title                    = "10 Most Recent Failed Jobs"
      column                   = 1
      height                   = 3
      row                      = 10
      width                    = 6
      linked_entity_guids      = []
      filter_current_dashboard = false

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM Log SELECT project.name as 'Project', job.name as 'Job Name',  job.number as 'Job Number', workflow.url as 'Workflow URL',job.status as 'Status', timestamp where job.status ='failed' limit 10 since 30 days ago"
      }
    }

    widget_table {
      title                    = "10 Most Recent Failed Workflows"
      column                   = 7
      height                   = 3
      row                      = 10
      width                    = 6
      linked_entity_guids      = []
      filter_current_dashboard = false

      nrql_query {
        account_id = var.nr_account_id
        query      = "FROM Log SELECT project.name as 'Project',workflow.name as 'workflow Name',  workflow.url as 'Workflow URL',workflow.status as 'status',timestamp where workflow.status ='failed' since 30 days ago limit 10"
      }
    }
  }
}
