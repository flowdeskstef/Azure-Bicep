Connect-AzAccount -Tenant $tenantId -UseDeviceAuthentication

# ================================
# VARIABLES (pas aan)
# ================================
$subscriptionId = "f7c1aa7e-cdef-4483-b00e-540d835a5950"
$tenantId       = "7b86d213-f413-419f-a3ee-1764ba5f1e99"
$rgNamemi         = "RG-AVD"

$klantnaam      = "laa"
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
