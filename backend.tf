terraform {
  backend "s3" {
    bucket         = "cloud-terraform-basics"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    use_lockfile = true
    encrypt        = true
  }
}