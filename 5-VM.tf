locals {
  subnet_ids = [
    azurerm_subnet.subnet_frontend_cus.id,
    azurerm_subnet.subnet_frontend_cus.id,

    azurerm_subnet.subnet_backend1_cus.id,
    azurerm_subnet.subnet_backend1_cus.id,

    azurerm_subnet.subnet_backend2_cus.id,
    azurerm_subnet.subnet_backend2_cus.id
  ]
}
# Bastion public ip that I'll attach to a particular subnet of the vnet 
resource "azurerm_public_ip" "bastion_pip_cus" {
  name                = "pip-bastion-cus"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Creation of the Bastion to allow private rdp connection
resource "azurerm_bastion_host" "bastion_cus" {
  name                = "bastion-cus"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku = "Standard"

  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = azurerm_subnet.bastion_subnet_cus.id
    public_ip_address_id = azurerm_public_ip.bastion_pip_cus.id
  }
}

#Creation of the Network Security group
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-Test-VM"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

#Rule to allow rdp connection from the Bastion subnet
  security_rule {
    name                       = "Allow-RDP-from-Bastion"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "10.0.200.0/26"
    destination_address_prefix = "*"
  }
 
}

#Creation of the NIC
resource "azurerm_network_interface" "nic" {
  count = length(local.subnet_ids)

  name                = "nic-Test-VM-${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = local.subnet_ids[count.index]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  count = length(local.subnet_ids)

  network_interface_id      = azurerm_network_interface.nic[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

#Creation of the Windows VMs
resource "azurerm_windows_virtual_machine" "winvm" {
  count = length(local.subnet_ids)
  name                = lower(replace(var.vm_names[count.index], "-", ""))
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id
  ]

  os_disk {
    name                 = "osdisk-cus-${count.index + 1}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}



#2 Creation of VMs for RG-NCUS

locals {
  subnet_ids_ncus = [
    azurerm_subnet.subnet_frontend_ncus.id,
    azurerm_subnet.subnet_frontend_ncus.id,

    azurerm_subnet.subnet_backend1_ncus.id,
    azurerm_subnet.subnet_backend1_ncus.id,

    azurerm_subnet.subnet_backend2_ncus.id,
    azurerm_subnet.subnet_backend2_ncus.id
  ]
}

resource "azurerm_public_ip" "public_ip_ncus" {
  count = length(local.subnet_ids_ncus)

  name                = "pip-NCUS-VM-${count.index + 1}"
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "nsg_ncus" {
  name                = "nsg-NCUS-VM"
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "73.132.226.28"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic_ncus" {
  count = length(local.subnet_ids_ncus)

  name                = "nic-NCUS-VM-${count.index + 1}"
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = local.subnet_ids_ncus[count.index]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_ncus[count.index].id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_ncus" {
  count = length(local.subnet_ids_ncus)

  network_interface_id      = azurerm_network_interface.nic_ncus[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg_ncus.id
}

resource "azurerm_windows_virtual_machine" "winvm_ncus" {
  count = length(local.subnet_ids_ncus)

  name                = lower(replace(var.vm_names_ncus[count.index], "-", ""))
  resource_group_name = azurerm_resource_group.rg2.name
  location            = azurerm_resource_group.rg2.location
  size                = "Standard_B1s"

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.nic_ncus[count.index].id
  ]

  os_disk {
    name                 = "osdisk-ncus-${count.index + 1}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}
