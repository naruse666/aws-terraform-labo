resource "aws_iam_service_linked_role" "ecs" {
  aws_service_name = "ecs.amazonaws.com"
}

resource "aws_ecs_cluster" "main" {
  name = var.name
  configuration {
    execute_command_configuration {
      kms_key_id = var.kms_key_id
      logging    = "OVERRIDE"
      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = var.log_group
      }
    }
  }
  depends_on = [ aws_iam_service_linked_role.ecs ]
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base = 1
    weight = 10
  }
  depends_on = [ aws_iam_service_linked_role.ecs ]
}