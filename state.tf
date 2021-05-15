terraform{
    backend "s3" {
        bucket = "gs-iac-pipeline"
        encrypt = true
        key = "terraform.tfstate"
        region = "us-east-1"
    }
}

#default region
provider "aws" {
    alias = "region-1"
    region = "us-east-1"
}

#secondary region
provider "aws" {
    alias = "region-2"
    region = "us-west-1"
}