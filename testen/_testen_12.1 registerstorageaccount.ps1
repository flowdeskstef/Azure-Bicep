
param(
    [string]$VaultName = "AVD-Vault",
    [string]$ResourceGroupName = "RG-STORAGE",
    [string]$StorageAccountName,
    [string]$FileShareName = "fslogix"
)

$vault = Get-AzRecoveryServicesVault -Name $VaultName
Set-AzRecoveryServicesVaultContext -Vault $vault

# Check of storage account al geregistreerd is
$container = Get-AzRecoveryServicesBackupContainer `
    -ContainerType AzureStorage `
    -FriendlyName $StorageAccountName `
    -Status Registered `
    -ErrorAction SilentlyContinue

if (-not $container) {

    $container = Register-AzRecoveryServicesBackupContainer `
        -ContainerType AzureStorage `
        -StorageAccountName $StorageAccountName
}