terraform {
  # backend "s3" {
  #   bucket = "d010642-tf-state-bucket"
  #   key = "devops/infrastructure/d010642.tfstate"
  #   region = "us-west-2"
  # }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">=5.39.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}