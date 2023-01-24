resource "aws_iam_role" "main" {
  name = var.name

  assume_role_policy = templatefile("${path.module}/role.json.tpl", {
    service_name = var.service_name
  })
}