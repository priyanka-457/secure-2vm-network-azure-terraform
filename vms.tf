
resource "azurerm_windows_virtual_machine" "jumpbox" {
  name                = "vm-windows-jump"
  computer_name       = "winjump"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_B2als_v2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.jumpbox.id
  ]

  os_disk {
    name                 = "osdisk-windows-jump"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }

  tags = {
    project = "Secure-2VM-Network"
    role    = "Jumpbox"
  }
}

resource "azurerm_linux_virtual_machine" "private" {
  name                            = "vm-linux-private"
  computer_name                   = "linuxprivate"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_B2als_v2"
  admin_username                  = var.admin_username
  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.private.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    name                 = "osdisk-linux-private"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    project = "Secure-2VM-Network"
    role    = "Private-Linux"
  }
}
