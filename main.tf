
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    project     = "Secure-2VM-Network"
    environment = "Learning"
    managed_by  = "Terraform"
  }
}
