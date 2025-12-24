output "alb_dns_name" {
  value = aws_lb.app_lb.dns_name
  description = "DNS name of the Application Load Balancer"
}

output "asg_name" {
  value = aws_autoscaling_group.web_asg.name
  description = "Auto Scaling Group name"
}
