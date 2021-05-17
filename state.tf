terraform {
  required_version = ">=0.15.3"

  backend "s3" {
    bucket  = "gs-iac-pipeline"
    encrypt = true
    key     = "terraform.tfstate"
    region  = "us-east-1"
  }
}