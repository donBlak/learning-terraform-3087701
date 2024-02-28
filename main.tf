data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

resource "aws_instance" "blog" {
  ami                    = data.aws_ami.app_ami.id
  instance_type          = var.instance_type

  vpc_security_group_ids = [module.blog_sg.security_group_id]

  tags = {
    Name = "Learing terraform"
  }
}

data "aws_vpc" "default" {
  default = true
}

module "blog_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "blog_instance_sg new"
  description = "Allow http and https request as in and allow all as out"

  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_rules            = ["http-80-tcp", "https-443-tcp"]

  egress_cidr_blocks      = ["0.0.0.0/0"]
  egress_rules            = ["all-all"]

}