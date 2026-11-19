# Get the existing default VPC
data "aws_vpc" "default" {
  default = true
}

# Get subnets belonging to the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Get the latest Amazon Linux 2023 AMI
data "aws_ssm_parameter" "amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Create a security group
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-sg"
  description = "Security group for Terraform EC2 project"
  vpc_id      = data.aws_vpc.default.id

  # No inbound rules for this initial project

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

# Create one EC2 instance
resource "aws_instance" "web" {
  ami                         = data.aws_ssm_parameter.amazon_linux.value
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = false

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name        = var.project_name
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}
