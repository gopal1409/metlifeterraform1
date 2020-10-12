provider "azurerm" {
    version = "~>2.0"
    features {}
}
# we will create a resource group
resource "azurerm_resource_group" "myterraform" {
    name = var.web_server_rg
    location = var.web_server_location
    tags = {
        environment = "Terraform Metlife"
    }
}
# creating a virtual network 
resource "azurerm_virtual_network" "myterraformnetwork" {
    name = "${var.resource_prefix}-vnet"
    address_space = [var.web_server_address_space]
    location = var.web_server_location
    resource_group_name = azurerm_resource_group.myterraform.name
    tags = {
        environment = "Terraform Metlife"
    }
}

resource "azurerm_subnet" "myterraformsubnet" {
    name = "${var.resource_prefix}-subnet"
    resource_group_name = azurerm_resource_group.myterraform.name
    virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
    address_prefixes = [var.web_server_address_prefix]

}
#to access resource across internet outside azure cloud to do the same we need to create an public ip
resource "azurerm_public_ip" "myterraformpublicip" {
    name = "${var.resource_prefix}-publicip"
    location = var.web_server_location
    resource_group_name = azurerm_resource_group.myterraform.name
    allocation_method = "Dynamic"
    tags = {
        environment = "Terraform Metlife"
    }

}

#network security group control the flow of network traffice in and out of your virtual_network_name

resource "azurerm_network_security_group" "myterraformnsg"{
    name = "${var.resource_prefix}-sg"
    location = var.web_server_location
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
 resource "azurerm_network_interface" "myterraformnic" {
     name = "${var.resource_prefix}-nic"
     location = var.web_server_location
     resource_group_name = azurerm_resource_group.myterraform.name

    ip_configuration {
        name = "${var.resource_prefix}-ip"
        subnet_id = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.myterraformpublicip.id
    }
    tags = {
        environment = "Terraform Metlife"
    }
    
    }
#connect the security group to this network interface 
    resource "azurerm_network_interface_security_group_association" "example" {
        network_interface_id = azurerm_network_interface.myterraformnic.id
        network_security_group_id = azurerm_network_security_group.myterraformnsg.id 
    }
resource "random_id" "randomid" {
    keepers = {
        #generate new id only when a new resource group is defined"
        resource_group_name = azurerm_resource_group.myterraform.name
    }
    byte_length = 8
}

resource "azurerm_storage_account" "mystorageaccount" {
    name = "diag${random_id.randomid.hex}"
    location = var.web_server_location
    resource_group_name = azurerm_resource_group.myterraform.name
    account_replication_type = "LRS"
    account_tier = "Standard"
    tags = {
        environment = "Terraform Metlife"
    }
}

resource "tls_private_key" "example_ssh" {
    algorithm = "RSA"
    rsa_bits = 4096
}

output "tls_private_key" { value = tls_private_key.example_ssh.private_key_pem }

resource "azurerm_linux_virtual_machine" "myterraformvm"{
    name = "${var.resource_prefix}-vm"
    location = var.web_server_location
    resource_group_name = azurerm_resource_group.myterraform.name
    network_interface_ids = [azurerm_network_interface.myterraformnic.id]
    size = "Standard_DS1_V2"

    os_disk {
        name = "${var.resource_prefix}-disk"
        caching = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }
    source_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "18.04-LTS"
        version = "latest"
    }

    computer_name = "myvm"
    admin_username = "gopal"
    admin_password = "Pass@123456"

    admin_ssh_key {
        username = "gopal"
        public_key = tls_private_key.example_ssh.public_key_openssh
    }
    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }
    tags = {
        environment = "Terraform Metlife"
    }

}
















