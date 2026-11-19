variable "aws_region" {
  description = "AWS region for deploying resources"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "project_name" {
  description = "Name of the Terraform project"
  type        = string
  default     = "terraform-ec2-demo"
}
