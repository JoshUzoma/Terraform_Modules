module "sp_dccc_s3_bucket" {
  source        = "../../modules/s3"
  company       = "sp"
  team          = "dccc"
  name          = "example-bucket-56689"
  environment   = "dev"
  force_destroy = true
}

module "tf_backend" {
  source              = "../../modules/tf_backend"
  company             = "sp"
  team                = "dccc"
  name                = "tfstate"
  environment         = "shared"    # Backend shared across all envs
  region              = "us-east-2"
}