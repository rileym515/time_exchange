##
# Basic Required Variables for terraformscaffold Components
##

variable "project" {
  type        = string
  description = "The project name"
  default     = "time-exchange"
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

variable "compiled_python" {
  type        = string
  description = "Path to Python code zip file"
}
