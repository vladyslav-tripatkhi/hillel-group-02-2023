variable "name" {
  type        = string
  description = "ALB name"
}

variable "security_group_id" {
  type = string
  # TODO: make it optional
  description = "ALB name"
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "tg_port" {
  type        = number
  default     = 8080
  description = "description"
}

variable "acm_certificate_arn" {
  type        = string
  default     = ""
  description = "description"
}
