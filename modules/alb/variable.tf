variable "name" {
  type        = string
  description = "alb name"
}

variable "internal" {
  type        = bool
  description = "internal type"
}

variable "subnets" {
  type        = list(any)
  description = "subnets list"
}

variable "security_groups" {
  type        = list(any)
  description = "security groups"
}