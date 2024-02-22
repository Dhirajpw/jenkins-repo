provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "instance" {
  for each = toset(var.ami_id)
  instance_type     = "t3.micro"
  key_name          = "dw-stockholm-key"
  ami               = "each.ami"
  availability_zone = "eu-north-1a"

  tags = {
    Name = "demo1"
  }
}

variable "ami-id" {
    default = ["ami-02d0a1cbe2c3e5ae4" , "ami-03035978b5aeb1274" , "ami-0014ce3e52359afbd"]
}