resource "aws_instance" "this" {
  count = var.instance_count

  ami = data.aws_ami.amazonlinux2.id

  user_data     = local.user_data
  instance_type = var.type
  key_name      = var.key_name

  tags = {
    Name = var.instance_count == 1 ? var.name : "${var.name}-${count.index}"
  }

  # <CONDITION> ? <RESULT IF TRUE> : <RESULT IF FALSE>

  vpc_security_group_ids = var.security_group_id != "" ? [var.security_group_id] : null

  lifecycle {
    ignore_changes = [ami]
  }
}