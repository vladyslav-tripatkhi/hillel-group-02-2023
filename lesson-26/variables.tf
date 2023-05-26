variable "subntets" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "description"
}

variable "instance_number" {
  type        = number
  default     = 2
  description = "description"
}

variable "key_name" {
  type        = string
  default     = "hillel-gr"
  description = "description"
}

locals {
  nginx_port   = 8181
  my_public_ip = lookup(data.external.my_ip.result, "ip", "127.0.0.1")
}
