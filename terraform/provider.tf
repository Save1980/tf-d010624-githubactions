terraform {
  # backend "s3" {
  #   bucket = "d010642-tf-state-bucket"
  #   key = "devops/infrastructure/d010642.tfstate"
  #   region = "eu-north-1"
  # }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">=5.39.0"
    }
  }
}

provider "aws" {
    region = "eu-north-1"
}