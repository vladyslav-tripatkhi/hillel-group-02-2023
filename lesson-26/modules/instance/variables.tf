variable "type" {
  type    = string
  default = "t3.micro"
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "key_name" {
  type        = string
  description = "description"
}

variable "name" {
  type = string
}

variable "port" {
  type    = number
  default = 8181
}

variable "security_group_id" {
  type        = string
  default     = ""
  description = "SG ID"

  validation {
    condition     = var.security_group_id == "" || startswith(var.security_group_id, "sg-")
    error_message = "Security Group Id must start with the prefix sg-."
  }
}

variable "user_data" {
  type        = string
  default     = ""
  description = "description"
}

locals {
  user_data = var.user_data != "" ? var.user_data : <<EOF
#!/usr/bin/env bash
yum install -y docker
usermod -aG docker ec2-user
systemctl enable docker
systemctl start docker
docker run -d --name nginx -p ${var.port}:80 nginx:alpine

  EOF
}
