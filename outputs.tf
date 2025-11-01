# Virtual Network Outputs
output "core_vnet_id" {
  description = "ID of the Core Services Virtual Network"
  value       = azurerm_virtual_network.core_vnet.id
}

output "manufacturing_vnet_id" {
  description = "ID of the Manufacturing Virtual Network"
  value       = azurerm_virtual_network.mfg_vnet.id
}

# Subnet Outputs
output "core_subnet_id" {
  description = "ID of the Core Services Subnet"
  value       = azurerm_subnet.core_subnet.id
}

output "manufacturing_subnet_id" {
  description = "ID of the Manufacturing Subnet"
  value       = azurerm_subnet.mfg_subnet.id
}

output "perimeter_subnet_id" {
  description = "ID of the Perimeter Subnet"
  value       = azurerm_subnet.perimeter_subnet.id
}

# Virtual Machine Outputs
output "core_vm_private_ip" {
  description = "Private IP Address of the Core Services VM"
  value       = azurerm_network_interface.core_nic.private_ip_address
}

output "manufacturing_vm_private_ip" {
  description = "Private IP Address of the Manufacturing VM"
  value       = azurerm_network_interface.mfg_nic.private_ip_address
}

# VNet Peering Status
output "core_to_manufacturing_peering_status" {
  description = "Status of VNet peering from Core to Manufacturing"
  value       = azurerm_virtual_network_peering.core-to-mfg.peering_state
}

output "manufacturing_to_core_peering_status" {
  description = "Status of VNet peering from Manufacturing to Core"
  value       = azurerm_virtual_network_peering.mfg-to-core.peering_state
}

# Route Table
output "route_table_id" {
  description = "ID of the Core Services Route Table"
  value       = azurerm_route_table.core_rt.id
}

# Resource Names (useful for future references)
output "resource_group_name" {
  description = "Name of the Resource Group"
  value       = data.azurerm_resource_group.rg.name
}

output "core_vm_name" {
  description = "Name of the Core Services VM"
  value       = azurerm_windows_virtual_machine.core_vm.name
}

output "manufacturing_vm_name" {
  description = "Name of the Manufacturing VM"
  value       = azurerm_windows_virtual_machine.mfg_vm.name
}
