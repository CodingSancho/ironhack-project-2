terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "viktor-voting-app-tf-state"
    key            = "voting-app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "viktor-voting-app-tf-lock"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}
