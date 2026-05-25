This project demonstrates the implementation of a secure VNet-to-VNet VPN Gateway architecture in Microsoft Azure using Terraform.

The objective of this lab was to understand how Azure Virtual Network Gateways establish encrypted communication between separate virtual networks located in different regions.

This project focuses on:
-----------------
Azure VPN Gateway
-----------------

Site-to-Site style VNet communication
Bidirectional VPN connections
GatewaySubnet configuration
Secure network routing
Infrastructure as Code with Terraform
Architecture
Regions Used
Region	Purpose
Central US (CUS)	Primary VNet
North Central US (NCUS)	Secondary VNet

---------------
Main Components
---------------

Networking
Azure Virtual Networks
GatewaySubnet
VNet-to-VNet VPN
Public IPs
Bidirectional VPN communication
Security
Encrypted communication between VNets
Shared authentication keys
Controlled routing between regions
Infrastructure as Code
Terraform deployment
Reusable resource structure
Automated provisioning
Features Implemented
GatewaySubnet

Each VNet contains a dedicated:

GatewaySubnet

This subnet is required for Azure Virtual Network Gateway deployment.

Virtual Network Gateway

Implemented:

Route-based VPN Gateway
Azure VPN Gateway SKU
Dynamic private IP allocation
Public IP association
Bidirectional Connections

Two VPN connections were configured:

Connection	Purpose
CUS → NCUS	Outbound communication
NCUS → CUS	Return traffic communication

This ensures full bidirectional communication between VNets.

Shared Key Authentication

VPN connections use a shared key to establish trust between gateways.

Example:

shared_key = "SuperSecureSharedKey123!"
Terraform Concepts Used
Terraform Resources

Examples:

azurerm_virtual_network_gateway
azurerm_virtual_network_gateway_connection
azurerm_public_ip
azurerm_subnet
Terraform Features

