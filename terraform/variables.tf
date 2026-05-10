variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
  default     = "viktor-useast1-dvft"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet (Instance A)"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_b_cidr" {
  description = "CIDR for private subnet B (Redis + Worker)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_c_cidr" {
  description = "CIDR for private subnet C (PostgreSQL)"
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_zone" {
  description = "AZ to deploy into"
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "EC2 instance type for all instances"
  type        = string
  default     = "t2.micro"
}

# Amazon Linux 2023 AMI for us-east-1 (update if region changes)
variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0ec10929233384c7f" # Ubuntu arm (us-east-1)
}

variable "project" {
  description = "Project tag applied to all resources"
  type        = string
  default     = "voting-app"
}

variable "owner" {
  description = "Owner name appended to all resource names and tags"
  type        = string
  default     = "viktor"
}
