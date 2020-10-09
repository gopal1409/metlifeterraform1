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
# creating a virtual network 
resource "azurerm_virtual_network" "myterraformnetwork" {
    name = "mvVnet"
    address_space = ["1.0.0.0/16"]
    location = "eastus"
    resource_group_name = azurerm_resource_group.myterraform.name
    tags = {
        environment = "Terraform Metlife"
    }
}

resource "azurerm_subnet" "myterraformsubnet" {
    name = "mysubnet"
    resource_group_name = azurerm_resource_group.myterraform.name
    virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
    address_prefixes = ["1.0.2.0/24"]

}
#to access resource across internet outside azure cloud to do the same we need to create an public ip
resource "azurerm_public_ip" "myterraformpublicip" {
    name = "myPublicIp"
    location = "eastus"
    resource_group_name = azurerm_resource_group.myterraform.name
    allocation_method = "Dynamic"
    tags = {
        environment = "Terraform Metlife"
    }

}










