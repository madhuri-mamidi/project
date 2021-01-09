resource "azurerm_resource_group" "rg" {
  name     = var.RGName
  location = var.location
}

resource "random_password" "password"{
    length  = 8
    special = true
}

resource "azurerm_storage_account" "storage" {
  name                     = "storage5627"
  resource_group_name      = var.RGName
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_server" "sqlserver" {
  name                         = "projnamedevsqlserver"
  resource_group_name          = var.RGName
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "admin"
  administrator_login_password = random_password.password.result

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.storage.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.storage.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }
  
  data "azurerm_sql_database" "sqldb" {
    name                = "sqldb"
    server_name         = azurerm_sql_server.sqlserver.name
    resource_group_name = var.RGName
  }

  tags = {
    environment = "dev"
  }
}