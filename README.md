# Azure Virtual Network Configuration with Terraform

This repository contains Terraform configuration for setting up Azure Virtual Networks with the following components:

## Architecture
- Core Services VNet with Core and Perimeter subnets
- Manufacturing VNet with dedicated subnet
- VNet Peering between Core and Manufacturing
- Windows VMs in both networks
- Custom routing configuration

## Prerequisites
- Azure Subscription
- Terraform installed
- Azure CLI installed and authenticated

## Configuration Files
- `main.tf` - Main Terraform configuration
- `variables.tf` - Variable definitions
- `locals.tf` - Local variables
- `terraform.tfvars` - Variable values (not committed - create from example)
- `outputs.tf` - Output definitions

## Usage
1. Clone this repository
2. Create a `terraform.tfvars` file with your values
3. Initialize Terraform:
   ```bash
   terraform init
   ```
4. Plan the deployment:
   ```bash
   terraform plan
   ```
5. Apply the configuration:
   ```bash
   terraform apply
   ```

## Security Note
- Ensure proper access controls are in place
- Review and modify network security rules as needed
- Keep credentials and sensitive data in `terraform.tfvars` (not committed to repo)
