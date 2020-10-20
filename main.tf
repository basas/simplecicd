variable "region" {
  type = string
  default = "eu-central-1"
}
variable "access_key" {
  type = string
   default = "none"
}
variable "secret_key" {
  type = string
   default = "none"
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "SG_DOCKER_MONITORING_WEB" {
  name        = "SG_DOCKER_MONITORING_WEB"
  description = "Allow Jenkins UI access"
  vpc_id      = data.aws_vpc.default.id
  ingress {
    description = "HTTP"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
      Name = "Security Group For DOCKER MONITORING system access"
  }
}

resource "aws_instance" "docker_monitoring" {
  ami = "ami-00a205cb8e06c3c4e"
  instance_type = "t2.micro"
  key_name      = module.ssh_key_pair.key_name
  security_groups = [ 
      aws_security_group.SG_DOCKER_MONITORING_WEB.name
  ]
  user_data = file("execute_in_ec2.sh")
  tags = {
    Name = "DOCKER_MONITORIN"
  }

}

module "ssh_key_pair" {
  source                = "git::https://github.com/cloudposse/terraform-aws-key-pair.git?ref=master"
  name                  = "docker_monitoring_web_server"
  ssh_public_key_path   = "."
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
}