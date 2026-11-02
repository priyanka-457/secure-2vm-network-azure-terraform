output "resource_group_name" {
  description = "Name of the Azure resource group"
  value       = azurerm_resource_group.main.name
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "windows_vm_name" {
  description = "Windows jumpbox VM name"
  value       = azurerm_windows_virtual_machine.jumpbox.name
}

output "windows_public_ip" {
  description = "Public IP address of the Windows jumpbox"
  value       = azurerm_public_ip.jumpbox.ip_address
}

output "linux_vm_name" {
  description = "Private Linux VM name"
  value       = azurerm_linux_virtual_machine.private.name
}

output "linux_private_ip" {
  description = "Private IP address of the Linux VM"
  value       = azurerm_network_interface.private.private_ip_address
}