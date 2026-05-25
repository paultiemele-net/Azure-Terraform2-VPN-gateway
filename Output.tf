# =========================
# VPN Gateway outputs
# =========================

output "vpn_gateway_public_ip_cus" {
  value = azurerm_public_ip.pip_vgw_cus.ip_address
}

output "vpn_gateway_public_ip_ncus" {
  value = azurerm_public_ip.pip_vgw_ncus.ip_address
}

output "vpn_connection_cus_to_ncus_name" {
  value = azurerm_virtual_network_gateway_connection.cus_to_ncus.name
}

output "vpn_connection_ncus_to_cus_name" {
  value = azurerm_virtual_network_gateway_connection.ncus_to_cus.name
}

# =========================
# VM private IPs
# =========================

output "vm_private_ips_cus" {
  value = azurerm_network_interface.nic[*].private_ip_address
}

output "vm_private_ips_ncus" {
  value = azurerm_network_interface.nic_ncus[*].private_ip_address
}

