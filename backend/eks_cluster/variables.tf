variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "platform_name" {
  description = "The name of the platform"
  type        = string
}

variable "platform_poc" {
  description = "The name of the platform proof of concept"
  type        = string
}

variable "cluster_version" {
  description = "The version of the EKS cluster"
  type        = string
}

variable "backend_bucket" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "key_state" {
  description = "The key of the S3 bucket"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "instance_type" {
  description = "The instance type of the EKS cluster"
  type        = string
}

variable "ami_type" {
  description = "The AMI type of the EKS cluster"
  type        = string
}

variable "test_name" {
  type = string
}