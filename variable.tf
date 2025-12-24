variable "instance_type" {
  description = "EC2 instance type for ASG"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for ASG instances"
  type        = string
  default     = "ami-02b8269d5e85954ef"
}

variable "asg_min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 1
}


variable "vpc_cidr_block" {}
variable "vpc_name" {}
variable "cidr_block" {}
variable "subnet_name" {}
variable "igw_name" {}
variable "sg_name" {}
variable "ingress_rules" {}
variable "ami" {}
variable "instance_type" {}
variable "instance_name" {}
variable "sg_description" {}
variable "availability_zone" {}

