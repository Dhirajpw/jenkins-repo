provider "aws" {
  region = "eu-north-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "my-vpc"
   }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "192.168.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-sub"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "192.168.16.0/24"

  tags = {
    Name = "private-sub"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "my-igw"
  }
}

resource "aws_route" "my_route" {
  route_table_id            = aws_vpc.vpc.default_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.igw.id
}

resource "aws_eip" "eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_sub.id

  tags = {
    Name = "my-nat"
  }
}

resource "aws_route_table" "private_route_t" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
}
resource "aws_route_table_association" "associate" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_t.id
}


resource "aws_instance" "demo" {
  ami           = "ami-0d87226fbb4ce71fe"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.my_security.id ]
  tags = {
    Name = "demo"
  }
}
resource "aws_security_group" "my_security" {
  name        = "http"
  description = "Allow http"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "my_inbound" {
  security_group_id = aws_security_group.my_security.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

}