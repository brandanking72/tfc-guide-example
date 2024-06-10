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
#-------------------------------------------------

provider "aws" {
  region = "us-east-1"
 }

resource "aws_instance" "webserver" {
  ami                    = "ami-00beae93a2d981137"
  instance_type          = "t2.micro"
  vpc_security_group_ids = "aws_security_group.web_sg.id"
  subnet_id              = "aws_instance.web_subnet"

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

# Create a VPC
resource "aws_vpc" "web_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "web_vpc"
  }
}

# Create a public subnet
resource "aws_subnet" "web_subnet" {
  vpc_id            = aws_vpc.web_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"  # Change the AZ as needed

  tags = {
    Name = "web_subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "terraform-igw" {
  vpc_id = aws_vpc.web_vpc.id

  tags = {
    Name = "terraform-igw"
  }
}

# Create a Route Table
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.web_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-igw.id
  }

  tags = {
    Name = "route_table"
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "route_table_assoc" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.route_table.id
}

# Create a Security Group
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.web_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_sg"
  }
}
