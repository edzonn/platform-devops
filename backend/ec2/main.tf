

# create security group for ec2 instance


resource "aws_instance" "platform-dev-test-ec2-01" {
  ami                    = var.ami_id
  instance_type          = "t2.medium"
  key_name               = "datadog-keypair"
  subnet_id              = data.terraform_remote_state.module_output.outputs.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.platform-dev-test-sg.id]
  # create iam instance profile
  iam_instance_profile = "ec2-ssm-role"
  tags = {
    Name = "platform-dev-test-ec2-master"
  }
  associate_public_ip_address = false

  #  root volume size gp3

  root_block_device {
    volume_size = 70
    volume_type = "gp3"
    iops        = 3000
    throughput  = 125
    encrypted   = false
    # kms_key_id = data.aws_kms_key.default.arn
    tags = {
      Name = "platform-dev-test-ec2-master"
    }

  }

  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = 8
    volume_type = "gp2"
  }

  # create ec2 instance user data with filebase64encode

  user_data = file("installer.sh")
}


resource "aws_instance" "platform-dev-test-ec2-02" {
  count                  = 2
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  key_name               = "datadog-keypair"
  subnet_id              = data.terraform_remote_state.module_output.outputs.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.platform-dev-test-sg.id]
  # create iam instance profile
  iam_instance_profile = "ec2-ssm-role"
  tags = {
    Name = "platform-dev-test-ec2-${count.index + 1}"
  }
  associate_public_ip_address = false


  #  root volume size gp3

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
    iops        = 3000
    throughput  = 125
    # encrypted = true
    # kms_key_id = data.aws_kms_key.default.arn
    tags = {
      Name = "platform-dev-test-ec2-02"
    }

  }

  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = 10
    volume_type = "gp2"
  }

  # create ec2 instance user data with filebase64encode

  user_data = file("installer.sh")
}


