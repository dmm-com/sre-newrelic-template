variable "nr_account_id" {
  type = number
}
variable "nr_api_key" {
  type = string
}

variable "nr_external_id" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "alert_policy_name" {
  type = string
}

variable "alert_slack_channel" {
  type = object({
    name    = string
    url     = string
    channel = string
  })
}

variable "slack_mention" {
  type = string
}

variable "newrelic_synthetics_ping" {
  type = list(object({
    name                      = string
    status                    = string
    uri                       = string
    validation_string         = string
    verify_ssl                = bool
    bypass_head_request       = bool
    treat_redirect_as_failure = bool
  }))
  default = []
}

variable "newrelic_synthetics_browser" {
  type = list(object({
    name                = string
    status              = string
    uri                 = string
    validation_string   = string
    verify_ssl          = bool
    bypass_head_request = bool
  }))
  default = []
}


variable "ec2_cpu_alerts" {
  type = list(object({
    name      = string
    tag_key   = string
    tag_value = string
  }))
  default = []
}

variable "ec2_alive_alerts" {
  type = list(object({
    name      = string
    tag_key   = string
    tag_value = string
  }))
  default = []
}

// New Relic の infrastructure agent を使用
variable "ec2_cpuiowait_alerts" {
  type = list(object({
    name      = string
    tag_key   = string
    tag_value = string
  }))
  default = []
}

// New Relic の infrastructure agent を使用
variable "ec2_disk_alerts" {
  type = list(object({
    name      = string
    tag_key   = string
    tag_value = string
  }))
  default = []
}

// New Relic の infrastructure agent を使用
variable "ec2_load_average_alerts" {
  type = list(object({
    name      = string
    tag_key   = string
    tag_value = string
  }))
  default = []
}

// New Relic の infrastructure agent と Flex を使用
// Flex については README に記載
variable "ec2_timesync_alerts" {
  type = list(object({
    name      = string
    tag_key   = string
    tag_value = string
  }))
  default = []
}

// New Relic の infrastructure agent を使用
variable "ec2_memory_alerts" {
  type = list(object({
    name      = string
    tag_key   = string
    tag_value = string
  }))
  default = []
}

variable "ec2_network_alerts" {
  type = list(object({
    name                     = string
    max_limit_bandwidth_mbps = number
    metrics_interval_minutes = number
    tag_key                  = string
    tag_value                = string
  }))
  default = []
}

variable "rds_alive_alerts" {
  type = list(object({
    name      = string
    tag_key   = string
    tag_value = string
  }))
  default = []
}

variable "rds_replica_lag_alerts" {
  type = list(object({
    name      = string
    tag_key   = string
    tag_value = string
  }))
  default = []
}

variable "rds_aurora_alive_alerts" {
  type = list(object({
    name      = string
    tag_key   = string
    tag_value = string
  }))
  default = []
}

variable "rds_aurora_replica_lag_alerts" {
  type = list(object({
    name      = string
    tag_key   = string
    tag_value = string
  }))
  default = []
}

// Elasticache はタグが取れない可能性あり
variable "elasticache_cpu_utilization_alerts" {
  type = list(object({
    name      = string
  }))
  default = []
}

variable "elasticache_swap_usage_alerts" {
  type = list(object({
    name      = string
  }))
  default = []
}

variable "elasticache_freeable_memory_alerts" {
  type = list(object({
    name      = string
  }))
  default = []
}

variable "elasticache_evictions_alerts" {
  type = list(object({
    name      = string
  }))
  default = []
}

variable "elasticache_currconnections_alerts" {
  type = list(object({
    name      = string
  }))
  default = []
}

variable "elasticache_redis_engine_cpu_utilization_alerts" {
  type = list(object({
    name      = string
  }))
  default = []
}

variable "elasticache_redis_replication_lag_alerts" {
  type = list(object({
    name      = string
  }))
  default = []
}

variable "elasticache_redis_database_memory_usage_percentage_alerts" {
  type = list(object({
    name      = string
  }))
  default = []
}

variable "cloudfront_4xx_alerts" {
  type = list(object({
    name      = string
  }))
  default = []
}

variable "cloudfront_5xx_alerts" {
  type = list(object({
    name      = string
  }))
  default = []
}

variable "cloudfront_origin_latency_alerts" {
  type = list(object({
    name      = string
  }))
  default = []
}

variable "elb_http_code_elb_5xx_count_alerts" {
  type = list(object({
    name      = string
  }))
  default = []
}

variable "elb_rejected_connection_count_alerts" {
  type = list(object({
    name      = string
  }))
  default = []
}

variable "elb_http_code_target_5xx_count_alerts" {
  type = list(object({
    name      = string
  }))
  default = []
}

variable "elb_target_connection_error_count_alerts" {
  type = list(object({
    name      = string
  }))
  default = []
}

variable "elb_alb_unhealthy_host_count_alerts" {
  type = list(object({
    name      = string
  }))
  default = []
}

variable "elb_port_allocation_error_count_alerts" {
  type = list(object({
    name      = string
  }))
  default = []
}

variable "elb_nlb_unhealthy_host_count_alerts" {
  type = list(object({
    name      = string
  }))
  default = []
}
