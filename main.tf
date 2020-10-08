provider "azurerm" {
    version = "~>2.0"
    features {}
}

# we will create a resource group
resource "azurerm_resource_group" "myterraform" {
    name = "myResourceGroup"
    location = "eastus"
    tags = {
        environment = "Terraform Metlife"
    }
}