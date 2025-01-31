variable "app_name" {
  description = "Name of the app"
  type        = string
}

variable "aws_region" {
  description = "Deployment target region"
  type        = string
}

variable "include_networking" {
  description = "Include nwtworking resources"
  type        = bool
}

variable "vpc_id" {
  description = "The VPC ID to use if networking is not included"
  type        = string
  default     = null
}

variable "subnet_a_id" {
  description = "The Security Group ID to use if networking is not included"
  type        = string
  default     = null
}

variable "subnet_b_id" {
  description = "The Security Group ID to use if networking is not included"
  type        = string
  default     = null
}

variable "security_group_id" {
  description = "The Security Group ID to use if networking is not included"
  type        = string
  default     = null
}

variable "internet_gateway_id" {
  description = "The Security Group ID to use if networking is not included"
  type        = string
  default     = null
}
