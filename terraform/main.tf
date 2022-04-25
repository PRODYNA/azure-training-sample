terraform {
  required_version = ">= 1.0"
  backend "azurerm" {
    subscription_id      = "3902cdee-a787-433e-b331-02b77bc9758c"
    resource_group_name  = "rg-traininig-1"
    storage_account_name = "pdazuretraining1"
    container_name       = "tf-state"
    key                  = "azure-terraform-training.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.2.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

locals {
  instances = [
    "i1",
    "i2",
  ]
}

#########################
# Ref to Resource Group #
#########################
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}
