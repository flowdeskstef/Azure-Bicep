Connect-AzAccount -Tenant $tenantId -UseDeviceAuthentication

# ================================
# VARIABLES (pas aan)
# ================================
$subscriptionId = "9a9de99b-cf05-4811-b143-aa928873225f"
$tenantId       = "18ff1127-1a1b-4d21-bc23-a6579436064c"
$rgNamemi         = "RG-AVD"

$klantnaam      = "andros"
$miName         = "AVD-MI"           # jouw managed identity naam
$keyVaultName   = "AVD-$klantnaam-KV"

# ================================
# LOGIN + CONTEXT
# ================================
Connect-AzAccount -Tenant $tenantId
Set-AzContext -Subscription $subscriptionId

# ================================
# MANAGED IDENTITY OPHALEN
# ================================
$mi = Get-AzUserAssignedIdentity -ResourceGroupName $rgNamemi -Name $miName

if (-not $mi) {
    throw "Managed Identity niet gevonden!"
}

$miObjectId = $mi.PrincipalId

Write-Host "Managed Identity ObjectId:" $miObjectId

# ================================
# ROLE ASSIGNMENT - SUBSCRIPTION
# ================================
$scopeSub = "/subscriptions/$subscriptionId"

New-AzRoleAssignment `
  -ObjectId $miObjectId `
  -RoleDefinitionName "Desktop Virtualization Virtual Machine Contributor" `
  -Scope $scopeSub

Write-Host "Role assigned: Desktop Virtualization Virtual Machine Contributor"

# ================================
# ROLE ASSIGNMENT - KEY VAULT
# ================================
$keyVault = Get-AzKeyVault -VaultName $keyVaultName
$scopeKv = $keyVault.ResourceId

New-AzRoleAssignment `
  -ObjectId $miObjectId `
  -RoleDefinitionName "Key Vault Secrets User" `
  -Scope $scopeKv

Write-Host "Role assigned: Key Vault Secrets User"

# ================================
# ROLE ASSIGNMENT - Custom Role
# ================================
$scopeSub = "/subscriptions/$subscriptionId"

New-AzRoleAssignment `
  -ObjectId $miObjectId `
  -RoleDefinitionName custom_images
  -Scope $scopeSub

Write-Host "Role assigned: Key Vault Secrets User"

# ================================
# DONE
# ================================
Write-Host "Klaar ✅"
