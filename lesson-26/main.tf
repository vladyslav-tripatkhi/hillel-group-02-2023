locals {
  instance_count = 1
}

module "instance" {
  source = "./modules/instance"

  name           = "hillel-server"
  key_name       = var.key_name
  instance_count = local.instance_count
  # security_group_id = aws_security_group.this.id
}

resource "aws_eip" "this" {
  count = local.instance_count

  tags = {
    Name = "eip-${count.index}"
  }
}

resource "aws_eip_association" "this" {
  count = local.instance_count

  instance_id   = module.instance.ids[count.index]
  allocation_id = aws_eip.this[count.index].id
}

resource "aws_security_group" "this" {
  name        = "hillel-lesson26-sg"
  description = "SG for test project for Hillel"

  vpc_id = data.aws_vpc.this.id
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.this.id

  description = "Allow SSH for me"
  cidr_ipv4   = "${local.my_public_ip}/32"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.this.id

  description = "Allow HTTP for me"
  cidr_ipv4   = "${local.my_public_ip}/32"
  ip_protocol = "tcp"
  from_port   = local.nginx_port
  to_port     = local.nginx_port
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id

  description = "Allow egress for all"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
}
