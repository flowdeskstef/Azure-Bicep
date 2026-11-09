Connect-AzAccount -Tenant $tenantId -UseDeviceAuthentication

# ================================
# VARIABLES (pas aan)
# ================================
$subscriptionId = "b4f6bed3-fd22-4722-861c-77a1ceb6c39f"
$tenantId       = "abd22615-fc1b-445e-9e69-484b27f9dd1b"
$rgNamemi         = "RG-AVD"

$klantnaam      = "nassaukeukens"
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
