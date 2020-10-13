provider "azurerm" {
    version = "~>2.0"
    features {}
}

provider "random" {
    version = "2.2"
}

module "location_us2w"{
    source = "./location"
    web_server_location = "westus2"
    web_server_rg = "${var.web_server_rg}-us2w"
    resource_prefix = ${var.resource_prefix}-us2w"
    web_server_address_space = "1.0.0.0/22"
    web_server_address_prefix = "1.0.2.0/24"
}
module "location_us2e"{
    source = "./location"
    web_server_location = "eastus2"
    web_server_rg = "${var.web_server_rg}-us2e"
    resource_prefix = ${var.resource_prefix}-us2e"
    web_server_address_space = "2.0.0.0/22"
    web_server_address_prefix = "2.0.2.0/24"
}