resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  assign_generated_ipv6_cidr_block = true

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, { Name = "${var.name}-vpc" })
}

resource "aws_internet_gateway" "this" {
  vpc_id     = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.name}-igw" })
}

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0
    # vpc   = true
  tags = merge(var.tags, { Name = "${var.name}-eip" })
}

resource "aws_nat_gateway" "this" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(var.tags, { Name = "${var.name}-natgw" })
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, {
    Name                          = "${var.name}-public-${count.index}"
    "kubernetes.io/role/elb"      = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "enabled"
  })
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, {
    Name                          = "${var.name}-private-${count.index}"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "enabled"
  })
}

resource "aws_subnet" "db" {
  count             = length(var.private_db_subnet_cidr)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_db_subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, { Name = "${var.name}-db-${count.index}" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, { Name = "${var.name}-pub-rtb" })
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.name}-priv-rtb-${count.index}" })
}

resource "aws_route" "private" {
  count                  = var.enable_nat_gateway ? length(var.private_subnet_cidr) : 0
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "db" {
  count          = length(var.private_db_subnet_cidr)
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.private[0].id
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = aws_subnet.db[*].id

  tags = merge(var.tags, { Name = "${var.name}-db-subnet-group" })
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  count = var.enable_flow_logs && var.flow_logs_destination_type == "cloud-watch-logs" && var.flow_logs_log_group_name == null ? 1 : 0

  name              = "/aws/vpc/${var.name}-flow-logs"
  retention_in_days = 30

  tags = merge(var.tags, { Name = "${var.name}-flow-logs" })
}

resource "aws_flow_log" "this" {
  count = var.enable_flow_logs ? 1 : 0

  log_destination_type = var.flow_logs_destination_type

  # If using CloudWatch Logs
  log_destination = (
    var.flow_logs_destination_type == "cloud-watch-logs" ?
    coalesce(var.flow_logs_log_group_name, aws_cloudwatch_log_group.flow_logs[0].arn) :
    var.flow_logs_s3_bucket_arn
  )

  iam_role_arn = (
    var.flow_logs_destination_type == "cloud-watch-logs" ?
    var.flow_logs_iam_role_arn : null
  )

  traffic_type = "ALL"
  vpc_id       = aws_vpc.this.id

  tags = merge(var.tags, { Name = "${var.name}-flow-logs" })
}

# resource "aws_flow_log" "this" {
#   count = var.enable_flow_logs ? 1 : 0

#   log_destination      = var.flow_logs_destination_type == "s3" ? var.flow_logs_s3_bucket_arn : null
#   log_destination_type = var.flow_logs_destination_type
#   traffic_type         = "ALL"
#   vpc_id               = aws_vpc.this.id

#   tags = merge(
#     var.tags,
#     { Name = "${var.name}-flow-logs" }
#   )
# }


