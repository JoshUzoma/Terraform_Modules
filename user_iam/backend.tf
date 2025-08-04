terraform {
  backend "s3" {
    bucket         = "devops-tf-state-sp"
    key            = "dev/user1_iam/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }
}