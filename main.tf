
terraform {
  required_version = "1.0.6"
}

terraform {
  required_version = "1.0.6"

  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 2.25.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.57.0"
    }
  }
}

provider "newrelic" {
  account_id = var.nr_account_id
  api_key    = var.nr_api_key
  region     = var.nr_region
}

provider "aws" {
  region = var.aws_region
}

resource "newrelic_synthetics_monitor" "ping" {
  count = length(var.newrelic_synthetics_ping)

  type                      = "SIMPLE"
  name                      = var.newrelic_synthetics_ping[count.index].name
  frequency                 = var.newrelic_synthetics_ping[count.index].frequency
  uri                       = var.newrelic_synthetics_ping[count.index].uri
  validation_string         = var.newrelic_synthetics_ping[count.index].validation_string
  verify_ssl                = var.newrelic_synthetics_ping[count.index].verify_ssl
  bypass_head_request       = var.newrelic_synthetics_ping[count.index].bypass_head_request
  treat_redirect_as_failure = var.newrelic_synthetics_ping[count.index].treat_redirect_as_failure
}

resource "newrelic_synthetics_monitor" "syn_browser" {
  count = length(var.newrelic_synthetics_browser)

  type                = "BROWSER"
  name                = var.newrelic_synthetics_browser[count.index].name
  frequency           = var.newrelic_synthetics_browser[count.index].frequency
  uri                 = var.newrelic_synthetics_browser[count.index].uri
  validation_string   = var.newrelic_synthetics_browser[count.index].validation_string
  verify_ssl          = var.newrelic_synthetics_browser[count.index].verify_ssl
  bypass_head_request = var.newrelic_synthetics_browser[count.index].bypass_head_request
}

resource "newrelic_alert_policy" "default" {
  name = "default"
}

resource "newrelic_alert_channel" "channel" {
  count = length(var.alert_slack_channel)

  type = "slack"
  name = var.alert_slack_channel[count.index].name

  config {
    url     = var.alert_slack_channel[count.index].url
    channel = var.alert_slack_channel[count.index].channel
  }
}

resource "newrelic_nrql_alert_condition" "cpu" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.cpu_alert_names)
  name  = var.cpu_alert_names[count.index]

  // TODO: ec2のタグ名を入れていないのであとで入れる
  nrql {
    query = "SELECT average(aws.ec2.CPUUtilization) FROM Metric WHERE collector.name ='cloudwatch-metric-streams' FACET entity.name SINCE 30 minutes ago"
  }
  critical {
    operator  = "above"
    threshold = 90
  }
}

resource "newrelic_nrql_alert_condition" "alive" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.alive_alert_names)
  name  = var.alive_alert_names[count.index]

  aws_account_ids = join(",", var.aws_account.ids)
  nrql {
    query = "SELECT average(receiveBytesPerSecond) FROM NetworkSample FACET entityAndInterface WHERE aws.accountId IN (${aws_account_ids}) SINCE 1 minutes ago"
  }
  critical {
    operator  = "equal"
    threshold = 0
  }
}

resource "newrelic_nrql_alert_condition" "cpu_iowait" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.cpuiowait_alert_names)
  name  = var.cpuiowait_alert_names[count.index]

  aws_account_ids = join(",", var.aws_account.ids)
  nrql {
    query = "SELECT average(cpuIOWaitPercent) FROM SystemSample FACET entityName WHERE aws.accountId IN (${aws_account_ids}) SINCE 5 minutes ago"
  }
  critical {
    operator  = "above"
    threshold = 20
  }
}

resource "newrelic_nrql_alert_condition" "disk" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.disk_alert_names)
  name  = var.disk_alert_names[count.index]

  aws_account_ids = join(",", var.aws_account.ids)
  nrql {
    query = "SELECT average(totalUtilizationPercent) FROM StorageSample FACET entityName WHERE aws.accountId IN (${aws_account_ids}) SINCE 1 minutes ago"
  }
  critical {
    operator  = "above"
    threshold = 90
  }
  warning {
    operator  = "above"
    threshold = 80
  }
}


resource "newrelic_nrql_alert_condition" "load_average" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.load_average_alert_names)
  name  = var.load_average_alert_names[count.index]

  aws_account_ids = join(",", var.aws_account.ids)
  nrql {
    query = "SELECT average(loadAverageFiveMinutes) FROM SystemSample FACET entityName WHERE aws.accountId IN (${aws_account_ids}) SINCE 1 minutes ago"
  }
  critical {
    operator  = "above"
    threshold = 5
  }
}

resource "newrelic_nrql_alert_condition" "timesync" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.timesync_alert_names)
  name  = var.timesync_alert_names[count.index]

  aws_account_ids = join(",", var.aws_account.ids)
  // TODO: chrony + 時刻同期を使って行う
  nrql {
    query = "SELECT average(loadAverageFiveMinutes) FROM SystemSample FACET entityName WHERE aws.accountId IN (${aws_account_ids}) SINCE 1 minutes ago"
  }
  critical {
    operator  = "above"
    threshold = 10
  }
}

resource "newrelic_nrql_alert_condition" "memory" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.memory_alert_names)
  name  = var.memory_alert_names[count.index]

  aws_account_ids = join(",", var.aws_account.ids)

  nrql {
    query = "SELECT average(memoryUsedPercent) FROM SystemSample FACET entityName WHERE aws.accountId IN (${aws_account_ids}) SINCE 1 minutes ago"
  }
  critical {
    operator  = "above"
    threshold = 90
  }
}

resource "newrelic_nrql_alert_condition" "network" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.alert_network)
  name  = var.alert_network.name[count.index]

  aws_account_ids = join(",", var.aws_account.ids)

  nrql {
    query = "SELECT average(memoryUsedPercent) FROM SystemSample FACET entityName WHERE aws.accountId IN (${aws_account_ids}) SINCE 1 minutes ago"
  }
  critical {
    operator  = "above"
    threshold = 90
  }
}

resource "newrelic_nrql_alert_condition" "rds_alive" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.rds_alive_alert_names)
  name  = var.rds_alive_alert_names[count.index]

  aws_account_ids = join(",", var.aws_account.ids)

  nrql {
    query = "SELECT average(aws.rds.NetworkThroughput) FROM Metrics FACET entityName WHERE aws.accountId IN (${aws_account_ids}) SINCE 5 minutes ago"
  }
  critical {
    operator  = "equal"
    threshold = 0
  }
}

resource "newrelic_nrql_alert_condition" "rds_replica_lag" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.rds_replica_lag_alert_names)
  name  = var.rds_replica_lag_alert_names[count.index]

  aws_account_ids = join(",", var.aws_account.ids)

  nrql {
    // TODO: レプリカラグがレプリカがないと取れなそうなので、NRQLで試す
    query = "SELECT average(aws.rds.ReplicaLag) FROM Metrics FACET entityName WHERE aws.accountId IN (${aws_account_ids}) SINCE 3 minutes ago"
  }
  critical {
    operator  = "above"
    threshold = 1
  }
}


resource "newrelic_nrql_alert_condition" "rds_connection" {
  policy_id = newrelic_alert_policy.default.id

  count = length(var.rds_connection_alert_names)
  name  = var.rds_connection_alert_names[count.index]

  aws_account_ids = join(",", var.aws_account.ids)

  nrql {
    // TODO: FACETがentityNameだとClientConnectionが、rds.targetだとmaxconnectionが取れないので、どうやって分割するか
    query = "SELECT average(aws.rds.ReplicaLag) FROM Metrics FACET entityName WHERE aws.accountId IN (${aws_account_ids}) SINCE 3 minutes ago"
  }
  critical {
    operator = "above"
    // todo: 割合は未定、あとで入れる
    threshold = 99
  }
}
