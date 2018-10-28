terraform {
  backend "azurerm" {
    storage_account_name = "azug11142018remotestate"
    container_name = "azug11142018-remotestate-demos"
    key = "2-demo.state"

    resource_group_name = "azug11142018-setup"
  }
}