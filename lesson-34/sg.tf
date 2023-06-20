resource "aws_security_group" "jenkins_alb" {
  name        = "jenkins-alb-sg"
  description = "SG for ALB for Hillel Jenkins test"

  vpc_id = data.aws_vpc.this.id
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_alb_ingress" {
  for_each = toset(["80", "443"])

  security_group_id = aws_security_group.jenkins_alb.id

  description = "Allow HTTP"
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = each.key
  to_port     = each.key
}

resource "aws_vpc_security_group_egress_rule" "jenkins_alb_egress" {
  security_group_id = aws_security_group.jenkins_alb.id

  referenced_security_group_id = aws_security_group.jenkins_instance.id
  description                  = "Allow egress for all"
  ip_protocol                  = "tcp"
  from_port                    = 8080
  to_port                      = 8080
}

resource "aws_security_group" "jenkins_instance" {
  name        = "jenkins-instance-sg"
  description = "SG for instance for Hillel Jenkins test"

  vpc_id = data.aws_vpc.this.id
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_instance_ingress" {
  for_each = {
    "ssh" = {
      port      = 22
      cidr_ipv4 = "0.0.0.0/0"
    }
    "alb" = {
      port  = 8080
      sg_id = aws_security_group.jenkins_alb.id
    }
  }

  security_group_id            = aws_security_group.jenkins_instance.id
  description                  = "Allow egress for all"
  cidr_ipv4                    = lookup(each.value, "cidr_ipv4", null)
  referenced_security_group_id = lookup(each.value, "sg_id", null)
  ip_protocol                  = "tcp"
  from_port                    = each.value.port
  to_port                      = each.value.port
}

resource "aws_vpc_security_group_egress_rule" "jenkins_instance_egress" {
  security_group_id = aws_security_group.jenkins_instance.id
  description       = "Allow egress for all"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  # from_port         = 0
  # to_port           = 0
}