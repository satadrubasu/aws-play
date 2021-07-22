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

variable "az_of_region" {
    description = "Enter the Availability Zone"
    default = "us-east-2a"
    type = string
 }

variable "ami_of_region" {
    description = "Enter the AMI ID"
    default = "ami-00399ec92321828f5"
    type = string
 }
## us-east-2 | Ubuntu AMIID - ami-00399ec92321828f5 (64-bit x86)

#resource "aws_instance" "tf_web" {
#  ami = "ami-00399ec92321828f5"
#  instance_type = "t2.micro"
#
#  tags = {
#    Name = "devops"
#  }
#}

########### VPCs  [ START ] ########################
resource "aws_vpc" "tf_web_vpc" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "web-vpc"
  }
}

resource "aws_vpc" "tf_shared_vpc" {
  cidr_block       = "10.2.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "shared-vpc"
  }
}

resource "aws_vpc" "tf_transit_vpc" {
  cidr_block       = "10.3.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "transit-vpc"
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
    Name = "web-pub"
  }
}

resource "aws_subnet" "tf_shared_pub" {
  vpc_id     = aws_vpc.tf_shared_vpc.id
  cidr_block = "10.2.254.0/24"
  availability_zone = var.az_of_region

  tags = {
    Name = "nat-pub"
  }
}

resource "aws_subnet" "tf_shared_pvt" {
  vpc_id     = aws_vpc.tf_shared_vpc.id
  cidr_block = "10.2.2.0/24"
  availability_zone = var.az_of_region

  tags = {
    Name = "database"
  }
}

resource "aws_subnet" "tf_transit_pub" {
  vpc_id     = aws_vpc.tf_transit_vpc.id
  cidr_block = "10.3.0.0/24"
  availability_zone = var.az_of_region

  tags = {
    Name = "transit"
  }
}
########### subnets  [ END ] ########################

########## Internet Gateways [ START ] ##############

resource "aws_internet_gateway" "tf_igw_web_vpc" {
  vpc_id = aws_vpc.tf_web_vpc.id

  tags = {
    Name = "web-vpc-igw"
  }
}

resource "aws_internet_gateway" "tf_igw_shared_vpc" {
  vpc_id = aws_vpc.tf_shared_vpc.id

  tags = {
    Name = "shared-vpc-igw"
  }
}

resource "aws_internet_gateway" "tf_igw_transit_vpc" {
  vpc_id = aws_vpc.tf_transit_vpc.id

  tags = {
    Name = "transit-vpc-igw"
  }
}
########## Internet Gateways [ END ] ##############

##########  Route Tables [ START ] ##############
# Note that the default route, mapping the VPC's CIDR block to "local", is created implicitly and cannot be specified.

resource "aws_route_table" "tf_web_rt" {
  vpc_id = aws_vpc.tf_web_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw_web_vpc.id
  }

  tags = {
    Name = "web-pub-rt"
  }
}

resource "aws_route_table" "tf_shared_pub_rt" {
  vpc_id = aws_vpc.tf_shared_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw_shared_vpc.id
  }

  tags = {
    Name = "shared-pub-rt"
  }
}

# define the pvt route table connected to vpc peering
#resource "aws_route_table" "tf_shared_pvt_rt" {
#  vpc_id = aws_vpc.tf_shared_pvt_vpc.id

#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.tf_igw_transit_vpc.id
#  }
#
#  tags = {
#    Name = "shared-pvt"
#  }
#}

resource "aws_route_table" "tf_transit_rt" {
  vpc_id = aws_vpc.tf_transit_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw_transit_vpc.id
  }

  tags = {
    Name = "transit-pub-rt"
  }
}

########## Route Tables [ END ] ###############

########## Route Tables Associations [ START ] ###############

resource "aws_route_table_association" "tf_web_rta" {
  subnet_id      = aws_subnet.tf_web_vpc_pub.id
  route_table_id = aws_route_table.tf_web_rt.id
}

resource "aws_route_table_association" "tf_shared_rta" {
  subnet_id      = aws_subnet.tf_shared_pub.id
  route_table_id = aws_route_table.tf_shared_pub_rt.id
}
resource "aws_route_table_association" "tf_transit_rta" {
  subnet_id      = aws_subnet.tf_transit_pub.id
  route_table_id = aws_route_table.tf_transit_rt.id
}
########## Route Tables Associations [ END ] ###############

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

########## Security Group [ END ] ###############

######### Network Interface [ START ] ###############

resource "aws_network_interface" "tf_web_eni" {
  subnet_id       = aws_subnet.tf_web_vpc_pub.id
  private_ips     = ["10.1.254.10"]
  security_groups = [aws_security_group.tf_sg_allow_public.id]
  tags = {
    Name = "web_network_interface"
  }

}

######### Network Interface [ END ] ###############


######### EC2 Instance [ START ] ###############
resource "aws_instance" "tf_web_inst" {
  ami           = var.ami_of_region
  instance_type = "t2.micro"
  availability_zone = var.az_of_region
  key_name = "terraform-devops"

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
    Name = "web-server"
  }
}
######### EC2 Instance [ END ] ###############
output "web_server_public_ip" {
  value = aws_instance.tf_web_inst.public_ip
}