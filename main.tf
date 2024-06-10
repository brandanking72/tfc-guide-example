# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0
# https://registry.terraform.io/

#resource "aws_instance" "example" {
  # Resource type: "aws_instance"
  # Resource name: "example"

  # Configuration settings for the resource
#  instance_type = "t2.micro"
#  ami           = "ami-12345678"
#  subnet_id     = "subnet-12345678"

  # Additional configuration settings as needed
#}



provider "aws" {
  region = "us-east-1"
 }

resource "aws_instance" "webserver" {
  ami                    = "ami-00beae93a2d981137"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-090ef33c74adf5f35"]
  subnet_id              = "subnet-0d1fa6cfcff239187"

  tags = {
    Name = "terraform-bk"
  }
}

resource "aws_security_group" "websg" {
  name        = "websg"
  description = "Security group for web servers"

  #// Ingress rule allowing inbound HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #// Egress rule allowing outbound traffic to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-00beae93a2d981137" # Replace with the AMI ID you want to use
  instance_type = "t2.micro"
  key_name      = "my-key-pair" # Replace with your key pair name

  network_interface {
    device_index          = 0
    subnet_id             = "subnet-0d1fa6cfcff239187" # Replace with your subnet ID
    security_groups       = ["sg-090ef33c74adf5f35"] # Replace with your security group ID
    associate_public_ip_address = false
  }
}

resource "aws_eip" "my_elastic_ip" {
  vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.my_ec2_instance.id
  allocation_id = aws_eip.my_elastic_ip.id
}

resource "aws_s3_bucket" "testbucket" {
  bucket = "terraform-bkbucket"

  tags = {
    Name        = "terraform-bkbucket"
    Environment = "Dev"
  }
}
