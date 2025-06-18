module "iam_roles" {
  source = "../modules/iam"

  for_each = var.iam_roles

  purpose                = each.value.purpose
  resource_type          = "iam"
  organization           = var.organization
  aws_region             = var.aws_region
  team                   = var.team
  env                    = var.env
  
  assume_role_services   = each.value.assume_role_services
  attach_basic_policy    = each.value.attach_basic_policy
  attach_xray_policy     = each.value.attach_xray_policy
  inline_policies        = each.value.inline_policies
  managed_policy_arns    = each.value.managed_policy_arns
}