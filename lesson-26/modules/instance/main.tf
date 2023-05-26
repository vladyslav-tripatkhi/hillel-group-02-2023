resource "aws_instance" "this" {
  count = var.instance_count

  ami = data.aws_ami.amazonlinux2.id

  user_data = <<EOF
#!/usr/bin/env bash
yum install -y docker
usermod -aG docker ec2-user
systemctl enable docker
systemctl start docker
docker run -d --name nginx -p ${var.nginx_port}:80 nginx:alpine

  EOF

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