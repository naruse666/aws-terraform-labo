variable "name" {
  type = string
  description = "ecs cluster name."
}

variable "kms_key_id" {
  type = string
  description = "ecs cluster log encription"
}

variable "log_group" {
  type = string
  description = "cloudwatch log group"
}