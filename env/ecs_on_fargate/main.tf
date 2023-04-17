module "ecs" {
  source     = "../../modules/ecs"
  name       = local.name
  kms_key_id = aws_kms_key.ecs.arn
  log_group  = aws_cloudwatch_log_group.ecs.name
}

module "ecs-sg" {
  source = "../../modules/sg"
  name   = "${local.name}-sg"
  vpc_id = module.vpc.vpc_id
  port   = 80
  cidr   = ["0.0.0.0/0"]
}

resource "aws_ecs_service" "service" {
  name             = "${local.name}-service"
  cluster          = module.ecs.id
  task_definition  = aws_ecs_task_definition.task.arn
  desired_count    = 1
  platform_version = "1.4.0"
  network_configuration {
    assign_public_ip = true
    subnets          = module.vpc.public_subnets
    security_groups  = [module.ecs-sg.id]
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 0
    weight            = 0
  }
  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 0
    weight            = 100
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "${local.name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions    = file("./task.json")
}

resource "aws_kms_key" "ecs" {
  description             = "ecs encription"
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "ecs" {
  name = "${local.name}-log-group"
}
