provider "aws" {
        region = "eu-north-1"
}

module "ec2" {
 source            = "./module/ec2"
 ami               = var.ami
 instance_type     = var.instance_type
 key_name          = var.key_name
 Name              = var.project

}
