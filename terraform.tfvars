vpc_cidr_block = "100.0.0.0/16"
vpc_name       = "vpc-for-lb-and-asg-project"

cidr_block = ["100.0.2.0/24" , "100.0.3.0/24"]
availability_zone = ["ap-south-1a" , "ap-south-1b"]
subnet_name       = ["public-terraform-subnet-1a" , "public-terraform-subnet-1b"]

igw_name = "terraform-igw"

sg_name        = "web-terraform-sg"
sg_description = "Allow SSH and HTTP"
ingress_rules = [
  {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr      = "0.0.0.0/0"
  },
  {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr      = "0.0.0.0/0"
  }
]

asg_min_size       = 1
asg_max_size       = 3
asg_desired_capacity = 1