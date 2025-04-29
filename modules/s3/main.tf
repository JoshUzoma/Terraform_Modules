resource "aws_s3_bucket" "example" {
  bucket        = local.resource_name
  force_destroy = var.force_destroy
  tags = local.default_tags
}