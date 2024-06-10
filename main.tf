# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

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

resource "aws_s3_bucket" "bucket" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "terraform-bkbucket"
    Environment = "Dev"
  }
}

