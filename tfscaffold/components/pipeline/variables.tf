##
# Basic Required Variables for terraformscaffold Components
##

variable "project" {
  type        = string
  description = "The project name"
}

variable "component" {
  type        = string
  default     = "pipeline"
}

variable "environment" {
  type        = string
}

variable "region" {
  type        = string
  description = "The AWS Region"
  default     = "us-east-2"
}

variable "default_tags" {
  type        = map(string)
  description = "A map of default tags to apply to all taggable resources within the component"
  default     = {}
}

variable "cwl_retention_days" {
  type        = string
  description = "Retention period in days for Cloudwatch Logs Log Groups for microservices in this component"
  default     = "7"
}
