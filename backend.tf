terraform {
  backend "s3" {
    bucket         = "cloud-terraform-basics"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "Terraform-state-locking"
    encrypt        = true
  }
}