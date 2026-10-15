terraform {
  backend "azurerm" {
    resource_group_name  = "rg-novacart-tfstate"
    storage_account_name = "stnovacarttfstate"
    container_name       = "tfstate"
    key                  = "novacart-dev.tfstate"

    use_azuread_auth = true
    use_cli           = true
  }
}