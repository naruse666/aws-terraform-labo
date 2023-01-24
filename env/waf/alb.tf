module "alb" {
  source          = "../../modules/alb"
  name            = "waf-alb"
  internal        = false
  subnets         = module.vpc.public_subnets
  security_groups = [module.sg.id]
}

module "sg" {
  source = "../../modules/sg"
  name   = "waf-alb-sg"
  vpc_id = module.vpc.vpc_id
  port   = "80"
  cidr   = ["0.0.0.0/0"]
}

resource "aws_lb_listener" "instance" {
  load_balancer_arn = module.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instance.arn
  }
}

resource "aws_lb_target_group" "instance" {
  name        = "instance-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_lb_target_group_attachment" "instance" {
  target_group_arn = aws_lb_target_group.instance.arn
  target_id        = aws_instance.web.id
  port             = 80
}