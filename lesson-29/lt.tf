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

resource "aws_launch_template" "this" {
  name = "hillel-lesson29-lt"

  instance_type = "t3.small"

  instance_market_options {
    market_type = "spot"
  }

  image_id = data.aws_ami.amazonlinux2.id

  user_data = filebase64("${path.module}/user_data.sh")

  key_name = "hillel-gr"

  # network_interfaces {
  #   associate_public_ip_address = true
  # }

  vpc_security_group_ids = [aws_security_group.instance.id]
}

resource "aws_autoscaling_group" "this" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 2
  max_size           = 5
  min_size           = 1

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "this" {
  autoscaling_group_name = aws_autoscaling_group.this.id
  lb_target_group_arn    = aws_lb_target_group.this.arn
}
