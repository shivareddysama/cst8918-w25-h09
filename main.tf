terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.70.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "fdcbdc66-325a-470d-957c-7977b0fb7718"  # Replace with your actual Azure Subscription ID
}


resource "azurerm_resource_group" "aks_rg" {
  name     = "aks-resource-group"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "myaks"

default_node_pool {
  name       = "default"
  vm_size    = "Standard_B2s"
  node_count = 1  # Reduce to 1 node to fit within the quota
}

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = "1.30.9"
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}
