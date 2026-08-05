
param (
    [string]$VMResourceGroup = "RG-COMPUTE",
    [string]$VMName = "avd-sh-0",
    [string]$LBResourceGroup = "RG-INFRA",
    [string]$LoadBalancerName = "AVD-LB",
    [string]$NatRuleName = "avd"
)

# Authenticate (assumes Managed Identity)
Connect-AzAccount -Identity

# Get the VM
$vm = Get-AzVM -ResourceGroupName $VMResourceGroup -Name $VMName

# Get NIC name
$nicId = $vm.NetworkProfile.NetworkInterfaces[0].Id
$nicName = ($nicId -split "/")[-1]

# Get NIC
$nic = Get-AzNetworkInterface -Name $nicName -ResourceGroupName $VMResourceGroup

# Get IP config
$ipConfig = $nic.IpConfigurations[0]

# Get the load balancer from its resource group
$lb = Get-AzLoadBalancer -Name $LoadBalancerName -ResourceGroupName $LBResourceGroup

# Find the NAT rule by name
$natRule = $lb.InboundNatRules | Where-Object { $_.Name -eq $NatRuleName }

if (-not $natRule) {
    throw "❌ NAT rule '$NatRuleName' not found on Load Balancer '$LoadBalancerName'."
}

# Attach the NAT rule to the NIC's IP config
$ipConfig.LoadBalancerInboundNatRules.Clear()
$ipConfig.LoadBalancerInboundNatRules.Add($natRule)

# Apply changes to NIC
Set-AzNetworkInterface -NetworkInterface $nic

Write-Output "✅ NAT rule '$NatRuleName' successfully associated with NIC '$nicName'."
