variable "project" {
  type = string
}

variable "location" {
  type = string
}

variable "suffix" {
  type = string
}

variable "suffix_short" {
  type = string
}

variable "os" {
  type = string
}

variable "hosting_plan" {
  type = string
}

resource "azurerm_resource_group" "resource_group" {
  name = "${var.project}-resource-group-${var.suffix}"
  location = var.location
}

resource "azurerm_storage_account" "storage_account" {
  name = "${var.project}strg${var.suffix_short}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location = var.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "${var.project}-app-service-plan-${var.suffix}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  kind                = var.hosting_plan == "premium" ? "elastic" : "FunctionApp"
  reserved            = var.os == "linux"
  sku {
    tier = var.hosting_plan == "premium" ? "ElasticPremium" : "Dynamic"
    size = var.hosting_plan == "premium" ? "EP1" : "Y1"
  }
}

resource "azurerm_function_app" "function_app" {
  name                       = "${var.project}-function-app-${var.suffix}"
  resource_group_name        = azurerm_resource_group.resource_group.name
  location                   = var.location
  app_service_plan_id        = azurerm_app_service_plan.app_service_plan.id
  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "",
    "FUNCTIONS_WORKER_RUNTIME" = "node",
    "WEBSITE_NODE_DEFAULT_VERSION": var.os == "windows" ? "~12" : null
  }
  os_type = var.os == "linux" ? "linux" : null
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  version                    = "~3"
  # version                    = "~2.0"
  
  # this is to avoid config drift being reported on app setting change after code deploy
  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
    ]
  }
}
