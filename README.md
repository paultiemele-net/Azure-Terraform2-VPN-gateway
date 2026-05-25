This project is a secure multi-region Azure networking architecture fully deployed with Terraform.
The goal of this lab was to practice real-world cloud networking and security concepts used in enterprise environments, including:

Hub and Spoke topology
Azure Firewall
Route Tables (UDR)
VPN Gateway
Bastion
Private Endpoint
Private DNS Zones
Storage Account hardening
NSG segmentation
Terraform Infrastructure as Code (IaC)

The environment was designed to simulate a production-style Azure infrastructure with secure communication between VNets, private services, and controlled administrative access.

------------
Architecture
------------

The lab contains three Azure regions:

Region	Purpose
Central US (CUS)	Spoke VNet
North Central US (NCUS)	Spoke VNet
Mexico Central (MEX)	Hub VNet

---------------
Main Components
---------------
Networking

Multiple VNets
Multiple subnets
Hub-and-Spoke topology
VNet Peering
VPN Gateway communication
User Defined Routes (UDR)
Security
Azure Firewall
Firewall Policy
Firewall Rules
Network Security Groups (NSGs)
Bastion private administration
Private DNS Zones
Private Endpoint for Storage Account
Storage Account with public access disabled
Compute
Windows Virtual Machines
Dedicated NICs
Private IP addressing
Storage
Azure Storage Account
Azure File Share
Private Endpoint access only
Private DNS integration
Features Implemented
Hub and Spoke Topology

The Mexico VNet acts as the Hub.
The CUS and NCUS VNets act as Spokes.
Traffic between spokes is routed through the Azure Firewall located in the Hub VNet.

Azure Firewall

Implemented:

Firewall Policy
Network Rule Collection
Spoke-to-Spoke traffic inspection
UDR routing through firewall private IP
VPN Gateway

Implemented VNet-to-VNet VPN communication between:

VNet-CUS
VNet-NCUS

Configured:

Bidirectional VPN connections
Shared keys
GatewaySubnet
Azure Bastion

Implemented Azure Bastion for secure VM administration.

Benefits:

No public IPs on production VMs
RDP over Azure Portal
Reduced attack surface
Private Endpoint

Implemented a Private Endpoint for Azure Storage File Share.

Benefits:

Storage accessible privately only
No public internet exposure
Integrated with Private DNS Zone
Private DNS Zones

Implemented:

Storage Private DNS Zone
Internal VM DNS Zone with auto-registration

Examples:

privatelink.file.core.windows.net
internal.mex.local
Terraform Concepts Used
Terraform Resources

Examples:

azurerm_virtual_network
azurerm_firewall
azurerm_private_endpoint
azurerm_bastion_host
azurerm_route_table
azurerm_virtual_network_gateway
Terraform Features

Used:

Variables
Outputs
Locals
Count
Resource associations
Modular resource organization
Security Design Decisions
Bastion Instead of Public IPs

Virtual Machines were designed to avoid direct public exposure.

Administrative access is performed securely through Azure Bastion.

Private Storage Access

Storage Accounts were configured with:

public_network_access_enabled = false

Access is allowed only through:

Private Endpoint
Private DNS
Internal Azure networking
Firewall Routing

User Defined Routes (UDRs) force spoke traffic through the Azure Firewall for centralized inspection and filtering.
