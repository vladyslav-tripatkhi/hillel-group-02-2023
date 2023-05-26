output "instance_public_ips" {
  value     = [for eip in aws_eip.this : eip.public_ip]
  sensitive = false

  depends_on = [aws_eip_association.this]
}

output "my_public_ip" {
  value     = local.my_public_ip
  sensitive = true
}

output "instance_ids" {
  value     = module.instance.ids
  sensitive = true
}