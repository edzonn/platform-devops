aws_region          = "ap-southeast-1"
s3_bucket_name      = "platform-terraform-state-201"
terraform_state_key = "terraform.state"
vpc_cidr_block      = "10.11.0.0/16"

private_subnet_names  = ["private-1", "private-2"]
database_subnet_names = ["database-1", "database-2"]
public_subnet_names   = ["public-1", "public-2"]
intra_subnet_names    = ["intra-1", "intra-2"]

tags = {
  PlatformPOC = "terraform-aws-vpc"
  PlatformORG = "platform"
}


# from_port       = -1
# to_port         = -1
# protocol        = "tcp"
# cidr_blocks     = ["0.0.0.0/0"]
# description     = "Allow all traffic"
# security_groups = null
# egress_rules    = null
# ingress_rules   = null

