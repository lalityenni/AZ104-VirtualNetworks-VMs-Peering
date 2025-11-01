# Azure Virtual Network Configuration with Terraform

Terraform configuration for Azure networking setup with dual VNets (Core and Manufacturing), bi-directional peering, Windows VMs, and custom routing. Includes perimeter subnet and future NVA integration. Designed for secure communication between core services and manufacturing networks.

## Infrastructure Overview

The project sets up the following Azure resources:

### 1. Virtual Networks
- **Core Services VNet**
  - Primary network for core business services
  - Contains Core subnet and Perimeter subnet
  - Address space defined in locals
  
- **Manufacturing VNet**
  - Dedicated network for manufacturing operations
  - Contains Manufacturing subnet
  - Separate address space for isolation

### 2. Virtual Machines
- **Core Services VM**
  - Windows Server 2019 Datacenter
  - Deployed in Core subnet
  - Size: Standard_D2s_v3
  
- **Manufacturing VM**
  - Windows Server 2019 Datacenter
  - Deployed in Manufacturing subnet
  - Size: Standard_D2s_v3

### 3. Network Connectivity
- **VNet Peering**
  - Bi-directional peering between Core and Manufacturing VNets
  - Allows direct communication between VMs
  - Configured with:
    - Virtual network access enabled
    - Forwarded traffic allowed
    - Gateway transit disabled

### 4. Network Security
- **Custom Route Table**
  - Applied to Core subnet
  - Routes traffic through a future Network Virtual Appliance (NVA)
  - Configured with next hop IP: 10.0.1.7

### 5. Network Interfaces
- Dedicated NICs for each VM
- Dynamic IP allocation
- Subnet-specific configurations

## Technical Details

### Network Architecture
- Implements hub-spoke networking concepts
- Utilizes Azure VNet peering for network connectivity
- Implements custom routing for future security appliance integration
- Supports future expansion with additional subnets and services

### Security Features
- Network isolation between different workloads
- Prepared for NVA implementation
- Custom route tables for traffic control
- Separate subnets for different security zones

### Deployment Features
- Modular Terraform configuration
- Uses data sources for existing resources
- Implements Azure tags for resource management
- Follows Azure naming conventions

## Prerequisites
- Azure Subscription
- Terraform installed
- Azure CLI installed and authenticated

## Project Structure

### Configuration Files
- `main.tf` - Primary configuration file containing all resource definitions
  - Virtual Network configurations
  - VM deployments
  - Network peering setup
  - Route table configurations
  
- `variables.tf` - Variable definitions for:
  - Azure location
  - Resource naming
  - Network configurations
  - VM credentials
  
- `locals.tf` - Local variables containing:
  - Resource naming conventions
  - Network address spaces
  - Common tags
  
- `outputs.tf` - Output definitions for:
  - Resource IDs
  - Network information
  - VM details
  
- `terraform.tfvars` - (Not committed - Create from example)
  - Contains sensitive configuration
  - Environment-specific values
  - Credentials and secrets

## Implementation Guide

### Prerequisites
1. Azure Subscription with required permissions
2. Terraform (>= 1.0.0)
3. Azure CLI installed and configured
4. Git for version control

### Required Variables
Create a `terraform.tfvars` file with:
```hcl
subscription_id     = "your-subscription-id"
location           = "your-azure-region"
admin_username     = "your-admin-username"
admin_password     = "your-admin-password"
```

### Deployment Steps
1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd az104-lab05-terraform
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review the deployment plan:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

### Post-Deployment
- Verify VNet peering status
- Confirm VM connectivity
- Test network routing
- Review security settings

## Best Practices and Security Considerations

### Security
- Store sensitive data in Azure Key Vault
- Use Azure RBAC for access control
- Implement network security groups (NSGs)
- Regular security audits and updates

### Networking
- Follow Azure networking best practices
- Implement proper network segmentation
- Plan IP address spaces carefully
- Document all custom routes

### Infrastructure as Code
- Use consistent naming conventions
- Implement proper tagging strategy
- Version control all configurations
- Use terraform workspaces for environments

### Maintenance
- Regular backup of state files
- Document all customizations
- Keep Terraform providers updated
- Monitor resource usage

## Support and Contribution
- Report issues through GitHub issues
- Follow contribution guidelines
- Maintain documentation
- Test before submitting PRs
