resource "azurerm_storage_account" "dl" {
  name                = "dl${replace(var.name, "-", "")}"
  location            = var.location
  resource_group_name = var.rg_name

  account_replication_type = "LRS"
  account_tier = "Standard"

  is_hns_enabled = true
}

resource "azurerm_role_assignment" "storage_rbac" {
  scope = azurerm_storage_account.dl.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id = data.azurerm_client_config.this.object_id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "container" {
  name               = "raw"
  storage_account_id = azurerm_storage_account.dl.id
}


resource "azurerm_data_factory" "df" {
  name                = "df-${var.name}"
  location            = var.location
  resource_group_name = var.rg_name

  identity {
    type = "SystemAssigned"
  }
}
