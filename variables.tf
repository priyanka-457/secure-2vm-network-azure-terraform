
variable "location" {
  description = "Azure region where all resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "rg-secure-2vm"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet-secure-lab"
}

variable "vnet_address_space" {
  description = "Address space of the virtual network"
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "jumpbox_subnet_name" {
  description = "Subnet name for Windows jump server"
  type        = string
  default     = "snet-jumpbox"
}

variable "jumpbox_subnet_prefix" {
  description = "Address range for Windows jump server subnet"
  type        = string
  default     = "10.10.1.0/24"
}

variable "private_subnet_name" {
  description = "Subnet name for private Linux server"
  type        = string
  default     = "snet-private"
}

variable "private_subnet_prefix" {
  description = "Address range for private Linux server subnet"
  type        = string
  default     = "10.10.2.0/24"
}

variable "admin_username" {
  description = "Administrator username for both virtual machines"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Strong administrator password for Windows VM"
  type        = string
  sensitive   = true
}

variable "allowed_rdp_cidr" {
  description = "Your public IP address in CIDR format for RDP access"
  type        = string
}

variable "ssh_public_key" {
  description = "Public SSH key used to access the private Linux VM"
  type        = string
}