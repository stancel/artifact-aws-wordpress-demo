resource "aws_default_vpc" "default" {
  tags {
    Name = "Default VPC"
  }
}

resource "random_id" "srvname" {
  byte_length = 8
}

resource "aws_security_group" "sgrp" {
  name        = "${random_id.srvname.hex}"
  description = "Allow HTTP/S and SSH traffic (port 80/443 and 22)"
  vpc_id      = "${aws_default_vpc.default.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
}

data "aws_ami" "app" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-wordpress-4.9.5-0-r13-linux-debian-9-x86_64-hvm-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"]
}

resource "aws_instance" "web" {
  ami                    = "${data.aws_ami.app.id}"
  instance_type          = "t2.small"
  vpc_security_group_ids = ["${aws_security_group.sgrp.id}"]
}
