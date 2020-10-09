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

#network security group control the flow of network traffice in and out of your virtual_network_name

resource "azurerm_network_security_group" "myterraformnsg"{
    name = "myNetworkSecurityGroup"
    location = "eastus"
    resource_group_name = azurerm_resource_group.myterraform.name
    security_rule {
        name = "SSH"
        priority = 1001
        direction = "Inbound"
        access = "Allow"
        protocol = "TCP"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
    tags = {
        environment = "Terraform Metlife"
    }

}





















