##############################################
# PROVIDERS
##############################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.2.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.10"
    }
  }
}
