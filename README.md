# Secure 2-VM Network on Azure Using Terraform

## 1. Project Overview

This project deploys a secure two-virtual-machine network in Microsoft Azure using Terraform.

It contanis two vms that are windows vm 2022 and a linux vm 22 .

The infrastructure is deployed and managed using Infrastructure as Code (IaC) with Terraform.

## 2. Project Objectives

- Create an Azure Resource Group and Virtual Network.
- Create separate subnets for the Windows jumpbox and private Linux VM.
- Deploy two virtual machines in the same virtual network.
- Allow RDP access to Windows only from the administrator's public IP.
- Allow SSH access to Ubuntu only from the Windows jumpbox's private IP.
- Deny other inbound Virtual Network traffic to the private VM.
- Verify connectivity and network security rules.
- Manage and remove the infrastructure using Terraform.

## 3. Architecture

**Access path:**

Laptop → RDP → Windows Jumpbox → SSH → Private Ubuntu VM

The laptop must not be able to connect directly to the private Ubuntu VM.

### Network configuration

| Component | Name | Address |
|---|---|---|
| Resource Group | rg-secure-2vm | — |
| Virtual Network | vnet-secure-lab | 10.10.0.0/16 |
| Jumpbox Subnet | snet-jumpbox | 10.10.1.0/24 |
| Private Subnet | snet-private | 10.10.2.0/24 |
| Windows VM | vm-windows-jump | 10.10.1.4 |
| Ubuntu VM | vm-linux-private | 10.10.2.4 |

Azure region: India South Central.

## 4. Security Configuration

### Jumpbox Network Security Group

Name: `nsg-jumpbox`

| Rule | Priority | Protocol | Port | Source | Action |
|---|---:|---|---:|---|---|
| Allow-RDP-From-My-IP | 100 | TCP | 3389 | Administrator public IP (/32) | Allow |

Unmatched inbound traffic is subject to Azure's default deny rule.

### Private VM Network Security Group

Name: `nsg-private`

| Rule | Priority | Protocol | Port | Source | Action |
|---|---:|---|---:|---|---|
| Allow-SSH-From-Jumpbox | 100 | TCP | 22 | 10.10.1.4/32 | Allow |
| Deny-Other-VNet-Inbound | 200 | Any | Any | VirtualNetwork | Deny |

The explicit deny rule is important because Azure has a default `AllowVnetInBound` rule at priority 65000. The custom deny rule at priority 200 is evaluated first and blocks other VNet inbound traffic.

## 5. Terraform Project Files

| File | Purpose |
|---|---|
| providers.tf | Terraform and Azure provider configuration |
| variables.tf | Input variable definitions |
| terraform.tfvars | Non-secret deployment settings |
| main.tf | Resource Group |
| network.tf | Virtual Network and subnets |
| security.tf | Network Security Groups and security rules |
| associations.tf | NSG-to-subnet associations |
| nics.tf | Network interfaces and public IP |
| vms.tf | Windows and Linux virtual machines |
| outputs.tf | Deployment output values |
| .gitignore | Excludes state files, secrets and local files |

Terraform state files and private keys must not be committed to source control.

## 6. Deployment Prerequisites

- Azure for Students subscription.
- Windows 11 computer.
- Azure CLI.
- Terraform.
- Visual Studio Code (optional).
- SSH key pair.
- Azure region and VM SKU permitted by the subscription.

## 7. Terraform Deployment Commands

Initialize Terraform:

```powershell
terraform init
```

Format the configuration:

```powershell
terraform fmt
```

Validate the configuration:

```powershell
terraform validate
```

Review the deployment plan:

```powershell
terraform plan
```

Deploy the infrastructure:

```powershell
terraform apply
```

Review the outputs:

```powershell
terraform output
```

## 8. Connectivity Testing

### Test 1: Laptop to Windows Jumpbox

- Connect using Remote Desktop Protocol (RDP).
- Use the Windows jumpbox public IP.
- RDP uses TCP port 3389.
- Access is restricted to the administrator's public IP address.

**Result: Successful.**

### Test 2: Windows Jumpbox to Private Ubuntu VM

From the Windows jumpbox, connect using:

```powershell
ssh -i "$env:USERPROFILE\.ssh\id_ed25519" azureuser@10.10.2.4
```

Verify the Ubuntu identity:

```bash
hostname
whoami
hostname -I
```

Expected identity:
- Hostname: linuxprivate
- Username: azureuser
- Private IP: 10.10.2.4

**Result: Successful.**

### Test 3: Direct Laptop to Private Ubuntu VM

From the administrator's laptop:

```powershell
Test-NetConnection 10.10.2.4 -Port 22
```

Expected result:

```text
TcpTestSucceeded : False
```

**Result: Direct SSH connection blocked as expected.**

## 9. Effective Network Security Verification

Azure CLI was used to inspect the effective NSG rules on both network interfaces.

Private VM:

```powershell
az network nic list-effective-nsg `
  --resource-group rg-secure-2vm `
  --name nic-linux-private `
  -o json
```

Windows jumpbox:

```powershell
az network nic list-effective-nsg `
  --resource-group rg-secure-2vm `
  --name nic-windows-jump `
  -o json
```

The effective rules confirmed that RDP is restricted to the configured administrator IP and SSH is restricted to the jumpbox private IP.

## 10. Cleanup

After completing testing and collecting evidence, remove all deployed Azure resources.

The initial cleanup was attempted using Terraform:

```powershell
terraform destroy
```

Due to intermittent connection resets from the Azure management API, the remaining Virtual Network and empty Resource Group were deleted using Azure CLI:

```powershell
az network vnet delete --resource-group rg-secure-2vm --name vnet-secure-lab

az group delete --name rg-secure-2vm --yes
```

Verify that the Resource Group no longer exists:

```powershell
az group exists --name rg-secure-2vm
```

Expected output:

```text
false
```

Remove the stale Resource Group entry from local Terraform state after confirming the Azure Resource Group has been deleted:

```powershell
terraform state rm azurerm_resource_group.main
```

Verify that Terraform state is empty:

```powershell
terraform state list
```

Final Terraform verification:

```powershell
terraform destroy
```

Expected output when no resources remain:

```text
No changes. No objects need to be destroyed.

Destroy complete! Resources: 0 destroyed.
```

The Azure Resource Group deletion and empty Terraform state were verified.

## 11. Conclusion

This project demonstrates how Terraform can automate Azure infrastructure deployment and how Network Security Groups can enforce controlled access between virtual machines.

The Windows jumpbox provides the approved administrative entry point, while the Ubuntu VM remains private and inaccessible through direct laptop SSH connections.

The deployment, RDP access, jumpbox-to-Ubuntu SSH access, direct SSH blocking, and effective NSG rules were verified.