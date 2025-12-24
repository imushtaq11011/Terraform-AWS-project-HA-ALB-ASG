provider "aws" {
    region = "ap-south-1"
  
}

module "vpc" {
  source = "./modules/vpc"
 
 vpc_cidr_block = var.vpc_cidr_block
 vpc_name = var.vpc_name
  
}

module "sg" {
    source = "./modules/sg"
    vpc_id = module.vpc_id
    sg_description = var.sg_description
    ingress_rules = var.ingress_rules
    sg_name = var.sg_name
  
}

module "internet_gateway" {
     source = "./modules/igw"
    vpc_id = module.vpc.vpc_id
     name = var.igw_name
 }

 
module "subnet" {
 source = "./modules/subnets"

  vpc_id = module.vpc.vpc_id

  cidr_block = var.cidr_block
 availability_zone = var.availability_zone
 name = var.subnet_name
  }



resource "aws_launch_template" "web_lt" {
  name          = "asg-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids  = [module.sg.sg_id]
}

# -------- Application Load Balancer --------
resource "aws_lb" "app_lb" {
  name               = "asg-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.security_group_id]
  subnets            = module.subnet_ids
}

resource "aws_lb_target_group" "app_tg" {
  name     = "asg-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# -------- Auto Scaling Group --------
resource "aws_autoscaling_group" "web_asg" {
  name                 = "web-asg"
  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  desired_capacity     = var.asg_desired_capacity
  vpc_zone_identifier  = module.subnet_ids
  target_group_arns    = [aws_lb_target_group.app_tg.arn]
  health_check_type    = "ELB"
  health_check_grace_period = 60

  tag {
    key                 = "Name"
    value               = "web-asg-instance"
    propagate_at_launch = true
  }
}

# -------- Scaling Policy & CloudWatch Alarm --------
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale_up_cpu"
  scaling_adjustment      = 1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 300
  autoscaling_group_name  = aws_autoscaling_group.web_asg.name
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "high_cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}
