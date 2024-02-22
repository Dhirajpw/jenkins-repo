provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "instance" {
  count             = "4"
  instance_type     = "t3.micro"
  key_name          = "dw-stockholm-key"
  ami               = "ami-02d0a1cbe2c3e5ae4"
  availability_zone = "eu-north-1a"

  tags = {
    Name = "demo1"
  }
}
