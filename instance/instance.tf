provider "aws" {
    region = "eu-north-1"
}

resource "aws_instance" "instance" {
    instance_type       = "t3.micro"
    key_name            = "dw-stockholm-key"
    ami                 = "ami-0d87226fbb4ce71fe"
    availability_zone   = "eu-north-1a"
    subnet_id           = "subnet-0c0c4a32c457f2424"

    tags =  {
        Name = "demo1"
    }
}



##if you want to launch an instance in "eu-north-1a" AZ then the subnet should be created in same AZ.
##ami should also be of the same configuration