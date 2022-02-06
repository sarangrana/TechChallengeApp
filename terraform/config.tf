terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

     random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
    
  }

#Adding remote Backend as S3 to store the state file
backend "s3" {
    bucket = "servian-remote-backend"
    key    = "servianterraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "s3-state-lock"
    shared_credentials_file = "~/.aws/config"
  }
}

# # Adding AWS Provider
provider "aws" {
    region = "us-east-2"
    shared_credentials_file = "~/.aws/config"
}