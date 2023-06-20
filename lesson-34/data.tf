data "aws_route53_zone" "this" {
  name = local.domain_name
  tags = {
    Terraform = false
  }
}

data "aws_vpc" "this" {
  tags = {
    Name = "default"
  }
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
}