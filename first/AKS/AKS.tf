resource "azurerm_container_registry" "acr"{
    location = var.location
    name     = var.acrname
    resource_group_name = var.rgname 
    sku = elemet(var.sku,1)
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "proj-aks1"
  location            = var.location
  resource_group_name = var.rgname
  kubernetes_version  = "1.17.11"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }
  
  service_principal {
    client_id = "xxxxxxxxxx"
    client_secret = "xxxxxx"
  }

  role_based_access_control{
      enabled = true
  }

  network_profile{
      network_plugin = element(var.network_profile, 1)
      load_balance_sku = element(var.network_profile, 2)
      network_policy = element(var.network_profile, 3)
  }

  tags = {
    Environment = "Production"
  }
}
