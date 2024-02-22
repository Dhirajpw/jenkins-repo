provider "aws" {
    region = "eu-north-1"
}

resource "aws_vpc" "main" {
    cidr_block = "192.168.0.0/16"

    tags = {
        Name = "demo-vpc"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = "aws_vpc.main.id"
    cidr_block = "192.168.0.0/24"
    availability_zone = "eu-north-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "subnet-pub"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = "aws_vpc.main.id"
    cidr_block = "192.168.0.0/24"
    availability_zone = "eu-north-1a"
    map_public_ip_on_launch = true

    tags = {
        Name = "private-pub"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = "aws_vpc.main.id"

    tags = {
        Name = "demo-igw"
    }
}

resource "aws_route" "route" {
  route_table_id            = aws_vpc.main.default_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.igw.id
}

resource "aws_eip" "eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "demo-nat"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "private_rt"
  }
}

resource "aws_route_table_association" "my_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_security_group" "my_security" {
  name        = "http"
  description = "Allow http"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "http"
  }
}

resource "aws_instance" "demo_vpc_instance" {
    instance_type = "t3.micro"
    ami = "ami-0d87226fbb4ce71fe"
    subnet_id = aws_subnet.public_subnet.id
    security_groups = [aws_security_group.my_security.id]

    tags = {
    Name = "demo_vpc_instance"
  }
}

resource "aws_vpc_security_group_ingress_rule" "inbound" {
  security_group_id = aws_security_group.my_security.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}