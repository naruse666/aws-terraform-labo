variable "name" {
  type = string
  description = "alb name"
}

variable "internal" {
  type = bool
  description = "internal type"
}

variable "subnets" {
  type = list
  description = "subnets list"
}

variable "security_groups" {
  type = list
  description = "security groups"
}