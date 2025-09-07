variable "name" { type = string }
variable "region" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "endpoint_sg_ids" { 
    type = list(string) 
    default = [] 
}
variable "interface_endpoints" {
  type = map(string)
  default = {
    "ecr.api"       = "ECR API"
    "ecr.dkr"       = "ECR Docker"
    "ecs"           = "ECS"
    "ecs-agent"     = "ECS Agent"
    "ecs-telemetry" = "ECS Telemetry"
  }
}
variable "gateway_endpoints" {
  type = map(string)
  default = {
    "s3" = "S3"
  }
}
variable "tags" { 
    type = map(string) 
    default = {} 
}
variable "route_table_ids" {
  type        = list(string)
  default     = []
}
