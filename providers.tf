provider "aws" {
  region = var.us-east
  alias  = "region-1"
}

provider "aws" {
  region = var.us-west
  alias  = "region-2"
}