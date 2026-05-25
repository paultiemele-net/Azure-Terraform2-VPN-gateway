# 1e Resource group avec 1 VNet divisé en 3 subnets
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}


# Vnet
resource "azurerm_virtual_network" "vnet_cus" {
  name                = "vnet-CUS"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# Subnets
resource "azurerm_subnet" "subnet_frontend_cus" {
  name                 = "subnet1-CUS"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_cus.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet_backend1_cus" {
  name                 = "subnet2-CUS"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_cus.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "subnet_backend2_cus" {
  name                 = "subnet3-CUS"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_cus.name
  address_prefixes     = ["10.0.3.0/24"]
}

# Bastion Subnet
resource "azurerm_subnet" "bastion_subnet_cus" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_cus.name
  address_prefixes     = ["10.0.200.0/26"]
}

# 2e Resource group avec 1 VNet divisé en 3 subnets


resource "azurerm_resource_group" "rg2" {
  name     = var.resource_group_name2
  location = var.location2
}

# Vnet
resource "azurerm_virtual_network" "vnet_ncus" {
  name                = "vnet-NCUS"
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name
  address_space       = ["10.1.0.0/16"]
}

# Subnets
resource "azurerm_subnet" "subnet_frontend_ncus" {
  name                 = "subnet1-NCUS"
  resource_group_name  = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.vnet_ncus.name
  address_prefixes     = ["10.1.1.0/24"]
  service_endpoints = ["Microsoft.Storage"]
}

resource "azurerm_subnet" "subnet_backend1_ncus" {
  name                 = "subnet2-NCUS"
  resource_group_name  = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.vnet_ncus.name
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_subnet" "subnet_backend2_ncus" {
  name                 = "subnet3-NCUS"
  resource_group_name  = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.vnet_ncus.name
  address_prefixes     = ["10.1.3.0/24"]
}


# GatewaySubnet for CUS VNet
resource "azurerm_subnet" "gateway_subnet_cus" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_cus.name
  address_prefixes     = ["10.0.250.0/27"]
}

# GatewaySubnet for NCUS VNet
resource "azurerm_subnet" "gateway_subnet_ncus" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.vnet_ncus.name
  address_prefixes     = ["10.1.250.0/27"]
}