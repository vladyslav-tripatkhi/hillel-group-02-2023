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

data "external" "my_ip" {
  program = ["curl", "-q", "https://api.ipify.org?format=json"]
}
