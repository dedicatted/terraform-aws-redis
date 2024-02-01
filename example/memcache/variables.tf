variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to deploy."
}

variable "cidr_block" {
  type        = string
  default     = "10.10.0.0/16"
  description = "CIDR block for the VPC."
}
variable "name" {
  type        = string
  default     = "example"
  description = "Name of all created resources"
}
variable "environment" {
  type        = string
  default     = "example"
  description = "Name of enviroment where you deployed elasticache"
}