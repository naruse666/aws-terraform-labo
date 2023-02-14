module "grafana_role" {
  source = "../../modules/iam/sts_role"
  name = "grafana-assume"
  service_name = "grafana.amazonaws.com"
}
resource "aws_grafana_workspace" "example" {
  name = "managed_grafana"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"]
  permission_type          = "SERVICE_MANAGED"
  role_arn                 = module.grafana_role.arn
}

resource "aws_grafana_role_association" "example" {
  role         = "ADMIN"
  user_ids     = [data.aws_identitystore_user.naruse.id]
  workspace_id = aws_grafana_workspace.example.id
}

data "aws_identitystore_user" "naruse" {
  identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]

  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = "Naruse"
    }
  }
}