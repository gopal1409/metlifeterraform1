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

resource "azurerm_virtual_network" "myterraformnetwork" {
    name = "mvVnet"
    address_space = ["10.0.0.0/16"]
    location = "eastus"
    resource_group_name = azurerm_resource_group.myterraform.name
    tags = {
        environment = "Terraform Metlife"
    }
}