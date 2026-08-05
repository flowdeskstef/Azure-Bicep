# Authenticate using the Managed Identity of the Automation Account
Connect-AzAccount -Identity

# Set variables
$ResourceGroupName = "RG-COMPUTE"
$VMName = "avd-sh-0"

# Get the VM
$vm = Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName

# Stop the VM
Write-Output "Stopping VM: $VMName"
Stop-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Force -NoWait

# Wait for the VM to be deallocated
do {
    Start-Sleep -Seconds 10
    $vmStatus = (Get-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName -Status).Statuses | Where-Object Code -like "PowerState/*"
    Write-Output "Current VM status: $($vmStatus.DisplayStatus)"
} while ($vmStatus.DisplayStatus -ne "VM deallocated")

# Get NIC
$nicId = $vm.NetworkProfile.NetworkInterfaces[0].Id
$nicName = ($nicId -split "/")[-1]
$nic = Get-AzNetworkInterface -Name $nicName -ResourceGroupName $ResourceGroupName

# Enable Accelerated Networking if not already enabled
if (-not $nic.EnableAcceleratedNetworking) {
    $nic.EnableAcceleratedNetworking = $true
    Set-AzNetworkInterface -NetworkInterface $nic
    Write-Output "Enabled Accelerated Networking on NIC: $nicName"
} else {
    Write-Output "Accelerated Networking is already enabled on NIC: $nicName"
}

# Start the VM
Write-Output "Starting VM: $VMName"
Start-AzVM -ResourceGroupName $ResourceGroupName -Name $VMName

Write-Output "Runbook completed successfully."
