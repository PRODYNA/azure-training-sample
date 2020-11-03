terraform {
  required_version = ">= 0.13"
  backend "azurerm" {
    resource_group_name  = "RG_TRAINING_[NAME]"
    storage_account_name = "satf[name]"
    container_name       = "tf-state"
    key                  = "azure-training-demo.tfstate"
    subscription_id      = "798e5b58-c51f-4934-8e45-809eccec7345"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.33.0"
    }
  }
}

provider "azurerm" {
  features {}
}

#########################
# Ref to Resource Group #
#########################
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}
