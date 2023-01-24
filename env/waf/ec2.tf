resource "aws_instance" "web" {
  ami             = "ami-0bba69335379e17f8"
  instance_type   = "t2.micro"
  subnet_id       = module.vpc.private_subnets[0]
  security_groups = [aws_security_group.web_sg.id]
  user_data       = <<EOF
	#!/bin/bash
	sudo amazon-linux-extras install nginx1 -y
	sudo systemctl start nginx
	EOF
  tags = {
    Name = "waf_test"
  }
}

resource "aws_security_group" "web_sg" {
  name   = "web-sg"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [module.sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}