terraform {
  # backend "s3" {
  #   bucket = "mybucket"
  #   key    = "path/to/my/key"
  #   region = var.region
  # }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.10"
    }
    # awscc = {
    #   source  = "hashicorp/awscc"
    #   version = "~> 0.57.0"
    # }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.44.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.2"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.0"
    }
    # vault = {
    #   source  = "hashicorp/vault"
    #   version = "~> 3.19.0"
    # }
  }
}

// set these as ENV vars or use the Makefile
# provider "aws" {
#   region = var.region
#   default_tags {
#     tags = local.aws_tags
#   }
# }

# provider "awscc" {
#   region = var.region
# }
# 
# provider "azuread" {
# }
# 
# provider "http" {
# }
# 
# provider "vault" {
# }

data "aws_caller_identity" "current" {}
