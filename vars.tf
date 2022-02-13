variable "region" {
  description = "Choose the region"
  default     = "us-east-1"
}

variable "environment" {
  description = "environment name"
  default     = "dev"
}


variable "subnet_cidr" {}

variable "instance_type" {
  default = "t2.micro"
}

# Variable for VPC
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}


# Declare the data source
data "aws_availability_zones" "azs" {}

variable "public_key" {}
variable "ami_name" {}
