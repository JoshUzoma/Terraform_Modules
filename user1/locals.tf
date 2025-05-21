locals {
  # Construct standardized resource name
  # Format: organization-team-resource name-environment (e.g., tomss-sp-lambda-dev)

  resource_name = "${var.organization}-${var.team}-${var.name}-${var.environment}"
  
  # Default tags to apply to all resources in this module
  default_tags = merge(
  {
    Name        = local.bucket_name
    ManagedBy   = "Terraform"
    Team        = var.team
    Environment = var.env
  },
  var.tags
 )
}