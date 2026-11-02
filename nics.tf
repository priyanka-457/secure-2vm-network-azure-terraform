resource "azurerm_public_ip" "jumpbox" {
  name                = "pip-windows-jump"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    project = "Secure-2VM-Network"
  }
}

resource "azurerm_network_interface" "jumpbox" {
  name                = "nic-windows-jump"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jumpbox.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.1.4"
    public_ip_address_id          = azurerm_public_ip.jumpbox.id
  }
}

resource "azurerm_network_interface" "private" {
  name                = "nic-linux-private"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Dynamic"
  }
}