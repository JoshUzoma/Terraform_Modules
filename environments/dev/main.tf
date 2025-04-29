module "sp_dccc_s3_bucket" {
  source        = "../../modules/s3"
  company       = "sp"
  team          = "dccc"
  name          = "example-bucket-56689"
  environment   = "dev"
  force_destroy = true
}