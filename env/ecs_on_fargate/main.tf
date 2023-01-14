module "ecs" {
  source     = "../../modules/ecs"
  name       = "ecs-on-fargate"
  kms_key_id = aws_kms_key.ecs.arn
  log_group  = aws_cloudwatch_log_group.ecs.name
}

module "ecs-sg" {
  source = "../../modules/sg"
  name   = "test-ecs-sg"
  vpc_id = module.vpc.vpc_id
  port   = 80
  cidr   = ["0.0.0.0/0"]
}

resource "aws_ecs_service" "test" {
  name             = "test-task"
  cluster          = module.ecs.id
  task_definition  = aws_ecs_task_definition.test.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  network_configuration {
    assign_public_ip = true
    subnets          = module.vpc.public_subnets
    security_groups  = [module.ecs-sg.id]
  }
}

resource "aws_ecs_task_definition" "test" {
  family                   = "test-task"
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
  name = "ecs-log"
}
