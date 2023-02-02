locals {
  terraform-git-repo = "nhd-exeter/dos-transformation-poc"
}

terraform {
  required_version = ">= 0.13.1"
  
  backend "s3" {
    bucket = "terraform8247833" # THIS MUST MATCH THE BUCKET NAME PROVIDED IN THE BOOTSTRAPPER
    key    = "state"
    region = "eu-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    },
    null = {
      source  = "hashicorp/null"
      version = ">= 2.0"
      }
    }
}

provider "aws" {
        default_tags {
          tags = {
              owner    = "DoS UEC"	
              project  = "DoS Transformation"
              terraform-base-path = replace(path.cwd,"/^.*?(${local.terraform-git-repo}\\/)/", "$1")
            }
        }
      }
