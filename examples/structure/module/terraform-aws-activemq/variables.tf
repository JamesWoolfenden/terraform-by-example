variable "common_tags" {
  description = "This is to help you add tags to your cloud objects"
  type        = map(any)
}

variable "mq_broker" {
  type        = map(any)
  description = "MQ broker details"
}

variable "subnet_ids" {
  description = "Contains subnet ids"
  type        = list(any)
}

variable "logs" {
  description = "Describes the logs block"
  type        = map(any)
  default = {
    general = "true"
    audit   = "false"
  }
}

variable "maintenance_window_start_time" {
  description = "Describe the Maintenance window block"
  type        = map(any)
  default = {
    day_of_week = "MONDAY"
    time_of_day = "12:05"
    time_zone   = "GMT"
  }
}


variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "my_config" {
  description = "MQ Config"
  type        = map(any)
}
