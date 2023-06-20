output "zone_id" {
  value       = aws_lb.this.zone_id
  sensitive   = true
  description = "description"
}

output "dns_name" {
  value       = aws_lb.this.dns_name
  sensitive   = true
  description = "description"
}

output "tg" {
  value = aws_lb_target_group.this
}
