output "ids" {
  value     = aws_instance.this[*].id
  sensitive = true
}
