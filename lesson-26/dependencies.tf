data "aws_vpc" "this" {
  tags = {
    Name = "default"
  }
}

data "external" "my_ip" {
  program = ["curl", "-q", "https://api.ipify.org?format=json"]
}
