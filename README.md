# Auto Scaling + Load Balancer Project

## Project Overview

This project demonstrates how to deploy a highly available web application using **Terraform**, **AWS Auto Scaling Group (ASG)**, and **Application Load Balancer (ALB)**. 

Key features:

- Multi-AZ deployment for high availability
- Auto scaling of EC2 instances based on CPU utilization
- Health checks to ensure only healthy instances serve traffic
- Reuse of existing VPC, subnets, and security groups

---

## Architecture Diagram

                   Internet
                       |
                    Route via IGW
                       |
                 -----------------
                 |      ALB      |
                 -----------------
                  |             |
           -------------------------------
           |                             |
    Subnet 1 (AZ1)                   Subnet 2 (AZ2)
      |                                 |
  EC2 Instance 1                    EC2 Instance 2
      |                                 |
  EC2 Instance 3                    EC2 Instance 4
      |                                 |
     ...                               ...
(ASG automatically scales instances in each AZ)




---

## Components Used

| Component                 | Terraform Resource                   | Purpose |
|---------------------------|-------------------------------------|---------|
| Launch Template           | aws_launch_template                  | Defines EC2 instance configuration |
| Application Load Balancer | aws_lb                               | Distributes incoming traffic across instances |
| Target Group              | aws_lb_target_group                  | Registers EC2 instances with ALB and defines health checks |
| Listener                  | aws_lb_listener                      | ALB listens on port 80 and forwards traffic to target group |
| Auto Scaling Group        | aws_autoscaling_group                | Automatically scales EC2 instances up/down |
| Scaling Policy            | aws_autoscaling_policy               | Defines scaling rules based on metrics |
| CloudWatch Alarm          | aws_cloudwatch_metric_alarm          | Monitors CPU utilization and triggers scaling |

---

## Terraform Files

- `variables.tf` : Defines all input variables
- `main.tf` : Contains resources for Launch Template, ALB, ASG, scaling policies
- `outputs.tf` : Outputs ALB DNS and ASG name
- `terraform.tfvars` : User-defined values for variables

---

## Terraform Commands

```bash
# Initialize Terraform
terraform init

# Preview changes before applying
terraform plan

# Apply changes and create resources
terraform apply


How it Works

Launch Template: Defines the configuration of EC2 instances including AMI, instance type, security groups, and user data script for web server setup.

Application Load Balancer: Receives all incoming traffic and distributes it across multiple EC2 instances in different subnets for high availability.

Target Group & Health Check: Registers instances to ALB and monitors health. Unhealthy instances will not receive traffic.

Auto Scaling Group: Launches EC2 instances in multiple subnets based on desired capacity. Scales automatically when CPU usage crosses thresholds.

Scaling Policy & CloudWatch Alarm: Monitors CPU utilization and triggers scale up when threshold is exceeded.

Testing

Access the ALB DNS from a browser: You should see the page message "Hello from Terraform ASG".

Simulate high CPU load: New instances should automatically launch.

Verify health checks: Only healthy instances serve traffic.

