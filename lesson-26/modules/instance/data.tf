data "aws_ami" "amazonlinux2" {
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners      = ["amazon"]
  most_recent = true
}
