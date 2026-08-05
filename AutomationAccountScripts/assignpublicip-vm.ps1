<#
.SYNOPSIS
Attach an existing Public IP to a VM’s NIC via Azure Automation (Managed Identity),
with all inputs hardcoded as plain text variables in the script.

.NOTES
- The script no longer uses or sets SubscriptionId.
- It executes in the subscription/context assigned to the Automation Account’s Managed Identity.
#>

# =========================
# >>> FILL THESE VALUES <<<
# =========================

# VM discovery (used if NIC is not explicitly set)
$VmResourceGroup      = "RG-COMPUTE"
$VmName               = "avd-sh-0"

# Public IP to attach (must already exist)
$PublicIpResourceGroup = "RG-INFRA"
$PublicIpName          = "avd-ip"

# Explicit NIC override (if both values are non-empty)
$NicResourceGroup     = "RG-COMPUTE"
$NicName              = "avd-sh-0-nic"

# Replace existing different PIP? ($true / $false)
$ForceReplace         = $false

# =========================
# End of user-configurable values
# =========================

$ErrorActionPreference = "Stop"

Write-Output "=== Attach existing PIP '$PublicIpName' (NO subscription ID used) ==="

# --- Auth ---
Connect-AzAccount -Identity | Out-Null

# Determine if explicit NIC is used
$useExplicitNic = (
    -not [string]::IsNullOrWhiteSpace($NicName) -and 
    -not [string]::IsNullOrWhiteSpace($NicResourceGroup)
)

# --- Resolve VM when NIC is not explicitly provided ---
if (-not $useExplicitNic) {
    Write-Output "Fetching VM '$VmName' in RG '$VmResourceGroup'..."
    $vm = Get-AzVM -ResourceGroupName $VmResourceGroup -Name $VmName -ErrorAction Stop
    $vmId = $vm.Id
    $vmLocation = $vm.Location
}

# --- Resolve NIC ---
if ($useExplicitNic) {
    Write-Output "Using explicit NIC: '$NicName' in RG '$NicResourceGroup'"
    $nic = Get-AzNetworkInterface -Name $NicName -ResourceGroupName $NicResourceGroup -ErrorAction Stop
}
else {
    $nicRefs = $vm.NetworkProfile.NetworkInterfaces

    if ($nicRefs -and $nicRefs.Count -gt 0) {
        $primaryNicRef = $nicRefs | Where-Object { $_.Primary -eq $true } | Select-Object -First 1
        if (-not $primaryNicRef) { $primaryNicRef = $nicRefs | Select-Object -First 1 }

        $parts = $primaryNicRef.Id -split "/"
        $nicNameDerived = $parts[-1]
        $nicRgDerived   = $parts[4]

        Write-Output "Primary NIC detected: Name='$nicNameDerived', RG='$nicRgDerived'"
        $nic = Get-AzNetworkInterface -Name $nicNameDerived -ResourceGroupName $nicRgDerived -ErrorAction Stop
    }
    else {
        Write-Warning "No NIC references found on VM. Trying VM-id fallback..."

        $allNics = Get-AzNetworkInterface
        $attached = $allNics | Where-Object { $_.VirtualMachine -and $_.VirtualMachine.Id -eq $vmId }

        if (-not $attached) { throw "No NICs found attached to the VM. Provide NIC override variables." }

        $nic = $attached | Where-Object { $_.Location -eq $vmLocation } | Select-Object -First 1
        if (-not $nic) { $nic = $attached | Select-Object -First 1 }

        Write-Output "Discovered NIC via VM-id fallback: '$($nic.Name)'"
    }
}

# --- Select primary IP configuration ---
$ipConfig = $nic.IpConfigurations |
    Sort-Object { if ($_.Primary) {0} else {1} } |
    Select-Object -First 1

if (-not $ipConfig) { throw "NIC '$($nic.Name)' has no IP configurations." }

Write-Output "Using primary IP configuration: '$($ipConfig.Name)'"

# --- Resolve Public IP ---
$publicIp = Get-AzPublicIpAddress -Name $PublicIpName -ResourceGroupName $PublicIpResourceGroup -ErrorAction Stop

# --- Region validation ---
if ($publicIp.Location -ne $nic.Location) {
    throw "Region mismatch: PIP '$($publicIp.Location)' vs NIC '$($nic.Location)'"
}

# --- Check existing PIP ---
$currentPipId = $ipConfig.PublicIpAddress?.Id

if ($currentPipId -and ($currentPipId -ne $publicIp.Id)) {
    if (-not $ForceReplace) {
        throw "This NIC IP config already has a different PIP. Set ForceReplace = \$true to override."
    }
    Write-Output "ForceReplace enabled: replacing existing PIP."
}
elseif ($currentPipId -eq $publicIp.Id) {
    Write-Output "PIP already attached. Nothing to do."
    return
}

# --- Attach PIP ---
Write-Output "Attaching PIP '$PublicIpName'..."
$ipConfig.PublicIpAddress = $publicIp
Set-AzNetworkInterface -NetworkInterface $nic | Out-Null

# --- Verify ---
$nicUpdated = Get-AzNetworkInterface -Name $nic.Name -ResourceGroupName $nic.ResourceGroupName
$updatedConfig = $nicUpdated.IpConfigurations | Where-Object { $_.Name -eq $ipConfig.Name }

Write-Output "Success! Attached PIP Resource ID:"