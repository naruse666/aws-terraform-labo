resource "aws_lb" "alb" {
  name = var.name
  internal           = var.internal
  load_balancer_type = "application"
  subnets = var.subnets
  security_groups = var.security_groups
}