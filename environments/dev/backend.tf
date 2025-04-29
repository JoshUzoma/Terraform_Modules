terraform {
  backend "s3" {
    bucket         = "sp-dccc-tfstate-bucket"
    key            = "dev/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "sp-dccc-tfstate-locks"
    encrypt        = true
  }
}