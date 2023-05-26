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

variable "nginx_port" {
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
