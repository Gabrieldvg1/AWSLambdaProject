provider "aws" {
  region = "eu-west-1" # Specify your desired region
}

terraform {
  backend "s3" {
    bucket         = "serverless-event-manager-terraform-backend"
    key            = "state/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "serverless-event-manager-terraform-locks"
    encrypt        = true
  }
}    