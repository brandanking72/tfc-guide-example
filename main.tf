# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
# https://registry.terraform.io/

provider "aws" {
  region = "us-east-1"
 }

resource "aws_instance" "app_server" {
  ami                    = "ami-00beae93a2d981137"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-090ef33c74adf5f35"]
  subnet_id              = "subnet-0d1fa6cfcff239187"

  tags = {
    Name = "terraform-bk"
  }
}

resource "aws_s3_bucket" "testbucket" {
  bucket = "terraform-bkbucket"

  tags = {
    Name        = "terraform-bkbucket"
    Environment = "Dev"
  }
}

# Define the load balancer resource
resource "aws_lb" "terraform-lb" {
  name               = "terraform-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [aws_subnet.public.id]

  enable_deletion_protection = false

  tags = {
    Name = "terraform-lb"
  }
}

# Define the security group for the load balancer
resource "aws_security_group" "lb_sg" {
  name        = "lb_sg"
  description = "Security group for the load balancer"
  
  #// Define your security group rules as needed
}


# Associate the EC2 instance with the load balancer
resource "aws_lb_target_group_attachment" "example" {
  target_group_arn = aws_lb_target_group.example.arn
  target_id        = aws_instance.example.id
  port             = 80
}

# Define the target group for the load balancer
resource "aws_lb_target_group" "example" {
  name     = "example-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.example.id
}

