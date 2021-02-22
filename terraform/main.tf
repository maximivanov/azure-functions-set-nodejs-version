terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # Root module should specify the maximum provider version
      # The ~> operator is a convenient shorthand for allowing only patch releases within a specific minor release.
      version = "~> 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  project = "azfuncnodever"
  location = "East US"
}

module "linux_premium" {
  source = "./modules/fa"
  
  project = local.project
  location = local.location
  suffix = "linux-premium"
  suffix_short = "lnxp"
  os = "linux"
  hosting_plan = "premium"
}

module "linux_consumption" {
  source = "./modules/fa"
  
  project = local.project
  location = local.location
  suffix = "linux-consumption"
  suffix_short = "lnxc"
  os = "linux"
  hosting_plan = "consumption"
}

module "windows_premium" {
  source = "./modules/fa"
  
  project = local.project
  location = local.location
  suffix = "windows-premium"
  suffix_short = "wndp"
  os = "windows"
  hosting_plan = "premium"
}

module "windows_consumption" {
  source = "./modules/fa"
  
  project = local.project
  location = local.location
  suffix = "windows-consumption"
  suffix_short = "wndc"
  os = "windows"
  hosting_plan = "consumption"
}
