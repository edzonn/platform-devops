variable "name" { type = string }
variable "region" { type = string }
variable "cluster_name" { type = string }
variable "vpc_cidr" { type = string }
variable "public_subnet_cidr" { type = list(string) }
variable "private_subnet_cidr" { type = list(string) }
variable "private_db_subnet_cidr" { type = list(string) }
variable "availability_zones" { type = list(string) }
variable "enable_nat_gateway" { 
    type = bool 
    default = true 
}
variable "tags" { 
    type = map(string) 
    default = {} 
}

variable "enable_flow_logs" {
  type    = bool
  default = false
}

variable "flow_logs_destination_type" {
  type    = string
  default = "cloud-watch-logs" # or "s3"
}

variable "flow_logs_log_group_name" {
  type    = string
  default = null
}

variable "flow_logs_s3_bucket_arn" {
  type    = string
  default = null
}

variable "flow_logs_iam_role_arn" {
  type    = string
  default = null
}

