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
  shared_credentials_file = "/Users/satbasu/.aws/credentials"
  profile                 = "alphauser"
  # Propogate default tags to all resources below
  default_tags {
    tags = {
      Source  = "Production"
      Project = "basicHelloApacheDNS"
    }
  }
}

variable "az_of_region" {
    description = "Enter the Availability Zone - [defaults to us-east-2a]"
    default = "us-east-2a"
    type = string
 }

variable "ami_of_region" {
    description = "Enter the AMI ID - Defaults to (Amazon Linux 2 AMI (HVM) ])"
    default = "ami-0443305dabd4be2bc"
    type = string
 }
## us-east-2 | Ubuntu AMIID - ami-00399ec92321828f5 (64-bit x86)
## us-east-2 | Amazon AMI - ami-0443305dabd4be2bc (64-bit x86)

########### VPCs  [ START ] ########################
resource "aws_vpc" "tf_web_vpc" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "basicHelloApache",
  }
}

########### VPCs  [ END ] ########################

########### subnets  [ START ] ########################

resource "aws_subnet" "tf_web_vpc_pub" {
  vpc_id     = aws_vpc.tf_web_vpc.id
  cidr_block = "10.1.254.0/24"
  availability_zone = var.az_of_region
  map_public_ip_on_launch = true
  depends_on = [aws_internet_gateway.tf_igw_web_vpc]

  tags = {
    Name = "basicHelloApache"
  }
}



########## Internet Gateways [ START ] ##############

resource "aws_internet_gateway" "tf_igw_web_vpc" {
  vpc_id = aws_vpc.tf_web_vpc.id

  tags = {
    Name = "bassicHelloApache-igw"
  }
}

##########  Route Tables [ START ] ##############
# Note that the default route, mapping the VPC's CIDR block to "local", is created implicitly and cannot be specified.

resource "aws_route_table" "tf_web_rt" {
  vpc_id = aws_vpc.tf_web_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw_web_vpc.id
  }

  tags = {
    Name = "basicHelloApache-rt"
  }
}

########## Route Tables Associations [ START ] ###############

resource "aws_route_table_association" "tf_web_rta" {
  subnet_id      = aws_subnet.tf_web_vpc_pub.id
  route_table_id = aws_route_table.tf_web_rt.id
}

########## Security Group [ START ] ###############

resource "aws_security_group" "tf_sg_allow_public" {
  name        = "allow_http_ssh"
  description = "Allow web/ssh inbound traffic"
  vpc_id      = aws_vpc.tf_web_vpc.id

  ingress {
    description      = "TLS from all"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "http from all"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "ssh from all"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_allow_tls_ssh"
  }
}

######### Network Interface [ START ] ###############

resource "aws_network_interface" "tf_web_eni" {
  subnet_id       = aws_subnet.tf_web_vpc_pub.id
  private_ips     = ["10.1.254.10"]
  security_groups = [aws_security_group.tf_sg_allow_public.id]
  tags = {
    Name = "web_network_interface"
  }
}

######### EC2 Instance [ START ] ###############
resource "aws_instance" "tf_web_inst" {
  ami           = var.ami_of_region
  instance_type = "t2.micro"
  availability_zone = var.az_of_region
  key_name = "mac-source"

  network_interface {
    network_interface_id = aws_network_interface.tf_web_eni.id
    device_index         = 0
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo apt systemctl start apache2
              sudo bash -c 'echo Your Apache web is saying Hello > /var/www/html/index.html'
              EOF
  tags = {
    Name = "basicHelloApacheWeb"
  }
}

############ OUTPUTS ##############

output "public_ip" {
  value     = aws_instance.tf_web_inst.public_ip
  description = "Public IP of the Instance"
}

