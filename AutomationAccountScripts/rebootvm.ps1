param(
    [string]$vmName = "avd-sh-0",
    [string]$resourceGroup = "RG-COMPUTE"
)

# Login with managed identity (make sure it’s enabled)
Connect-AzAccount -Identity

# Restart the VM forcefully
Restart-AzVM -ResourceGroupName $resourceGroup -Name $vmName