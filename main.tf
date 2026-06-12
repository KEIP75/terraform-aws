provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "efekan_sg" {
  name   = "efekan_sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "efekan_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "efekan_sg_allow_tls" {
  security_group_id = aws_security_group.efekan_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "efekan_sg_allow_ssh" {
  security_group_id = aws_security_group.efekan_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22

}

resource "aws_vpc_security_group_ingress_rule" "efekan_sg_allow_all" {
  security_group_id = aws_security_group.efekan_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_key_pair" "efekan_keypair" {
  key_name   = "efekan_keypair"
  public_key = file("~/.ssh/terraform-ipssi.pub")
}


resource "aws_instance" "efekan_serverweb_mv" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.my_instance_type
  subnet_id                   = var.subnet_id
  key_name                    = aws_key_pair.efekan_keypair.key_name
  associate_public_ip_address = true
  security_groups             = [aws_security_group.efekan_sg.id]

  tags = {
    Name = "TR-Batchi-Kocak"
  }
}
