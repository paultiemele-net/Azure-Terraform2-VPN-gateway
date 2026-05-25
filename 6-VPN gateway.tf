

resource "azurerm_public_ip" "pip_vgw_cus" {
  name                = "pip-vgw-cus"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "pip_vgw_ncus" {
  name                = "pip-vgw-ncus"
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_virtual_network_gateway" "vgw_cus" {
  name                = "vgw-cus"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"
  sku      = "VpnGw1"

  ip_configuration {
    name                          = "vgw-cus-ipconfig"
    public_ip_address_id          = azurerm_public_ip.pip_vgw_cus.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet_cus.id
  }
}

resource "azurerm_virtual_network_gateway" "vgw_ncus" {
  name                = "vgw-ncus"
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name

  type     = "Vpn"
  vpn_type = "RouteBased"
  sku      = "VpnGw1"

  ip_configuration {
    name                          = "vgw-ncus-ipconfig"
    public_ip_address_id          = azurerm_public_ip.pip_vgw_ncus.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet_ncus.id
  }
}

# Connection CUS to NCUS
resource "azurerm_virtual_network_gateway_connection" "cus_to_ncus" {
  name                = "conn-cus-to-ncus"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vgw_cus.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.vgw_ncus.id

  shared_key = "paultiemele"
}

# Connection NCUS to CUS
resource "azurerm_virtual_network_gateway_connection" "ncus_to_cus" {
  name                = "conn-ncus-to-cus"
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name

  type                            = "Vnet2Vnet"
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.vgw_ncus.id
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.vgw_cus.id

  shared_key = "paultiemele"
}