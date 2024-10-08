terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}

provider "aws" {
  access_key = var.akey
  secret_key = var.skey
  region     = "us-east-1"
}

terraform {
  cloud {

    organization = "Rob-NWG-IAC"

    workspaces {
      name = "Test-1"
    }
  }
}