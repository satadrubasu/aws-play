terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.50.0"
    }
  }
}

provider "aws" {
  # Configuration options
  # us-east-2 = Ohio
  region = "us-east-2"
  shared_credentials_file = "/home/satadru/.aws/credentials"
  profile                 = "alphauser"
}

## us-east-2 | Ubuntu AMIID - ami-00399ec92321828f5 (64-bit x86)

resource "aws_instance" "tf_web" {
  ami = "ami-00399ec92321828f5"
  instance_type = "t2.micro"

  tags = {
    Name = "devops"
  }
}