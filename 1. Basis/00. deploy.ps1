#connect naar klantomgeving
Connect-AzAccount

#resource providers
Register-AzResourceProvider -ProviderNamespace Microsoft.VirtualMachineImages
Register-AzResourceProvider -ProviderNamespace Microsoft.Compute
Register-AzResourceProvider -ProviderNamespace Microsoft.KeyVault
Register-AzResourceProvider -ProviderNamespace Microsoft.ManagedIdentity
Register-AzResourceProvider -ProviderNamespace Microsoft.Storage
Register-AzResourceProvider -ProviderNamespace Microsoft.DesktopVirtualization
Register-AzResourceProvider -ProviderNamespace Microsoft.Network
Register-AzResourceProvider -ProviderNamespace Microsoft.ContainerInstance

#resourcegroupdeployment
New-AzDeployment -Location "westeurope" -TemplateFile "01. resourcegroups.bicep"

#natgateway
New-AzResourceGroupDeployment -ResourceGroupName "RG-INFRA" -TemplateFile "02. natgateway.bicep"

#nsg
New-AzResourceGroupDeployment -ResourceGroupName "RG-INFRA" -TemplateFile "03. nsg.bicep"

#network
New-AzResourceGroupDeployment -ResourceGroupName "RG-INFRA" -TemplateFile "04. network.bicep"

#load balancer
New-AzResourceGroupDeployment -ResourceGroupName "RG-INFRA" -TemplateFile "05. loadbalancer.bicep"

#servers
New-AzResourceGroupDeployment -ResourceGroupName "RG-COMPUTE" -TemplateFile "06. servers.bicep"

#keyvault
New-AzResourceGroupDeployment -ResourceGroupName "RG-AVD" -TemplateFile "07. keyvault.bicep"

#mi + compute gallery
New-AzResourceGroupDeployment -ResourceGroupName "AVD" -TemplateFile "08. mi + compute gallery.bicep"

#mi role
New-AzDeployment -Location "westeurope" -TemplateFile "08.1 mi rbac role.bicep"

#rbac roles
.\"08.2 rbac roles.ps1"

#custom image template
.\"09. deploy_CIT.ps1"

#host pool
New-AzResourceGroupDeployment -ResourceGroupName "RG-AVD" -TemplateFile "10. avd - intune.bicep"

#scaling plan
New-AzResourceGroupDeployment -ResourceGroupName "RG-AVD" -TemplateFile "10.1 scaling plan.bicep"

#hide prompt, kan zijn dat je deze in los powershell venster moet openen ivm graph api
.\"10.2 hidepromt.ps1"

#storage account
New-AzResourceGroupDeployment -ResourceGroupName "RG-STORAGE" -TemplateFile "11. storageaccount.bicep"

#storage account-pe
New-AzResourceGroupDeployment -ResourceGroupName "RG-INFRA" -TemplateFile "11.1 storageaccount - pe.bicep"

#backup vault
New-AzResourceGroupDeployment -ResourceGroupName "RG-STORAGE" -TemplateFile "12. backup vault.bicep"

#register vault storage account
New-AzResourceGroupDeployment -ResourceGroupName "RG-INFRA" -TemplateFile "12.1 backup vault - pe.bicep"

#image updater
.\"13. Deploy_ImageUpdate.ps1"
.\"13.1 Run_ImageUpdate.ps1"
.\"13.2 Update_HostPool.ps1"

# aa schedule

# reboot avd
# 1 Am
# 2 Am
# 3 Am

# rdp nat
# 2:30 am

# acc networking
# 3:30 am