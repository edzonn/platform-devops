
resource "aws_security_group" "platform-dev-test-lb" {
  name        = "platform-dev-test-lb"
  description = "platform-dev-test-lb"
  vpc_id      = data.terraform_remote_state.module_output.outputs.vpc_id
  ingress {
    from_port   = 4545
    to_port     = 4545
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 4545
    to_port     = 4545
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "platform-dev-test-lb"
  }
}

resource "aws_security_group" "test" {
  name        = "test"
  description = "test"

  vpc_id = data.terraform_remote_state.module_output.outputs.vpc_id

  ingress {
    from_port   = var.allowed_ports[0]
    to_port     = var.allowed_ports[0]
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = var.allowed_ports[0]
    to_port     = var.allowed_ports[0]
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "egress" {
    for_each = var.allowed_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}


resource "aws_security_group" "platform-dev-test-sg" {
  name        = "platform-dev-test-sg"
  description = "platform-dev-test-sg"
  vpc_id      = data.terraform_remote_state.module_output.outputs.vpc_id
  ingress {
    from_port       = 4545
    to_port         = 4545
    protocol        = "tcp"
    security_groups = [aws_security_group.platform-dev-test-lb.id]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "platform-dev-test-sg"
  }
}

