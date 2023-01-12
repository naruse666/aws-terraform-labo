variable "name" {
  type = string
  description = "sg name"
}

variable "vpc_id" {
  type = string
  description = "vpc id"
}

variable "port" {
  type = number
  description = "port number"
}

variable "cidr" {
  type = list
  description = "cidr block"
}