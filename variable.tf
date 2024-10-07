# variables.tf

variable "aws_region" {
  description = "The AWS region to deploy the resources"
  default     = "us-east-1"
}

variable "ami" {
  description = "The AMI ID to use for the instance"
  default     = "ami-005fc0f236362e99f"
}

variable "instance_type" {
  description = "The instance type to use for the EC2 instance"
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the key pair to use for the instance"
  default     = "workstation-key"
}

