resource "aws_security_group" "fallback" {
  count = var.security_group_id == "" ? 1 : 0
}