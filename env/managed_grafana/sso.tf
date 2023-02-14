data "aws_ssoadmin_instances" "example" {}
data "aws_caller_identity" "current" {}
resource "aws_ssoadmin_permission_set" "example" {
  name             = "GrafanaSSO"
  description      = "test managed grafana SSO"
  instance_arn     = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  session_duration = "PT2H"
}

resource "aws_ssoadmin_managed_policy_attachment" "example" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/AWSGrafanaAccountAdministrator"
  permission_set_arn = aws_ssoadmin_permission_set.example.arn
}

resource "aws_identitystore_group" "example" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
  display_name      = "GrafanaSSOGroup"
  description       = "test managed grafana"
}

resource "aws_ssoadmin_account_assignment" "example" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.example.arn

  principal_id   = aws_identitystore_group.example.group_id
  principal_type = "GROUP"

  target_id   = data.aws_caller_identity.current.account_id
  target_type = "AWS_ACCOUNT"
}
