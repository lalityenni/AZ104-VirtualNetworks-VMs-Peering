terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id                 = var.subscription_id
  resource_provider_registrations = "none"
}

data "azurerm_resource_group" "rg" {
  name = local.resource_group_name
}

#Vnet creations and subnets
resource "azurerm_virtual_network" "core_vnet" {
  name                = local.core_vnet_name
  address_space       = [local.core_vnet_address]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.common_tags
}

resource "azurerm_subnet" "core_subnet" {
  name                 = local.core_subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.core_vnet.name
  address_prefixes     = [local.core_subnet_address]
}


# Manufacturing VNet
resource "azurerm_virtual_network" "mfg_vnet" {
  name                = local.manufacturing_vnet_name
  address_space       = [local.manufacturing_vnet_address]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.common_tags
}

resource "azurerm_subnet" "mfg_subnet" {
  name                 = local.manufacturing_subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.mfg_vnet.name
  address_prefixes     = [local.manufacturing_subnet_address]
}

# ---------------------------------------------
# Step 2A: Core Services Virtual Machine
# ---------------------------------------------

# Network Interface for CoreServices

resource "azurerm_network_interface" "core_nic" {
  name                = "${local.core_vm_name}-nic"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "core-ip-config"
    subnet_id                     = azurerm_subnet.core_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
# Virtual Machine for CoreServicesVM
resource "azurerm_windows_virtual_machine" "core_vm" {
  name                  = local.core_vm_name
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = var.location
  network_interface_ids = [azurerm_network_interface.core_nic.id]
  size                  = "Standard_D2s_v3"
  admin_username        = var.admin_username
  admin_password        = var.admin_password

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = local.common_tags
}

# ---------------------------------------------
# Step 2B: Manufacturing Virtual Machine
# ---------------------------------------------

# Network Interface for ManufacturingVM
resource "azurerm_network_interface" "mfg_nic" {
  name                = "${local.manufacturing_vm_name}-nic"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "mfg-ip-config"
    subnet_id                     = azurerm_subnet.mfg_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Windows VM for Manufacturing Services
resource "azurerm_windows_virtual_machine" "mfg_vm" {
  name                  = local.manufacturing_vm_name
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = var.location
  network_interface_ids = [azurerm_network_interface.mfg_nic.id]
  size                  = "Standard_D2s_v3"
  admin_username        = var.admin_username
  admin_password        = var.admin_password

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = local.common_tags
}

# ---------------------------------------------
# Step 3: VNet Peering between Core and Manufacturing
# ---------------------------------------------
#core to manufacturing peering
resource "azurerm_virtual_network_peering" "core-to-mfg" {
  name                         = "core-to-mfg-peering"
  resource_group_name          = data.azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.core_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.mfg_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
  allow_gateway_transit        = false

}
#manufacturing to core peering
resource "azurerm_virtual_network_peering" "mfg-to-core" {
  name                         = "mfg-to-core-peering"
  resource_group_name          = data.azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.mfg_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.core_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
  allow_gateway_transit        = false

}

#create a new subnet in the Core VNET called perimeter

resource "azurerm_subnet" "perimeter_subnet" {
  name                 = local.perimeter_subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.core_vnet.name
  address_prefixes     = [local.perimeter_subnet_address]
}


# Route table for CoreServices
resource "azurerm_route_table" "core_rt" {
  name                          = local.route_table_name
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = var.location
  
  tags                          = local.common_tags
}

# Custom route (future NVA)
resource "azurerm_route" "perimeter_to_core" {
  name                   = "PerimeterToCore"
  resource_group_name    = data.azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.core_rt.name
  address_prefix         = local.core_vnet_address        # 10.0.0.0/16
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "10.0.1.7"                     # Future NVA IP
}

# Associate route table with Core subnet
resource "azurerm_subnet_route_table_association" "core_rt_assoc" {
  subnet_id      = azurerm_subnet.core_subnet.id
  route_table_id = azurerm_route_table.core_rt.id
}