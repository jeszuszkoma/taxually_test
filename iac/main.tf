terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "Terraform-POC"
    storage_account_name = "resourcetest12"
    container_name = "state"
    key = "terraform.state"
  }
}

provider "azurerm" {
  skip_provider_registration = "true"
  features {
  }
}