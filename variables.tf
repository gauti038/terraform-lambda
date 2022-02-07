variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "logs_retention_in_days" {
  description = "The number of days you want to retain logs in cloudwatch"
  type        = number
  default     = 1
}


