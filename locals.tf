locals {
  #vnet configurations
  resource_group_name      = "kml_rg_main-46449b3ba7674df8"
  core_vnet_name           = "CoreServicesVnet"
  core_vnet_address        = "10.0.0.0/16"
  core_subnet_name         = "Core"
  core_subnet_address      = "10.0.0.0/24"
  perimeter_subnet_name    = "perimeter"
  perimeter_subnet_address = "10.0.1.0/24"

  manufacturing_vnet_name      = "ManufacturingVnet"
  manufacturing_vnet_address   = "172.16.0.0/16"
  manufacturing_subnet_name    = "Manufacturing"
  manufacturing_subnet_address = "172.16.0.0/24"

  #VM names
  core_vm_name          = "CoreServicesVM"
  manufacturing_vm_name = "ManufacturingVM"

  #Route Table
  route_table_name = "rt-CoreServices"
  route_name       = "PerimetertoCore"
  nva_ip_address   = "10.0.1.7" # Future Network Virtual Appliance IP

  common_tags = {
    Environment = "Lab"
    Lab         = "az104-lab05"
    ManagedBy   = "Terraform"
  }
}
  