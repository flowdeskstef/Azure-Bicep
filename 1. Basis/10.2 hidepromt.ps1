# maak een nieuwe groep aan in de tenant:
# 🔒💻 Virtual Machines
# dynamic device query:
# (device.displayName -startsWith "avd")

# --- Tenant & scopes ---
$tenant = Read-Host "Enter your Tenant ID (GUID) or verified domain (e.g. contoso.com)"

$scopes = @(
  "Application.Read.All",
  "Application-RemoteDesktopConfig.ReadWrite.All",
  "Group.Read.All",
  "Directory.Read.All"
)
Connect-MgGraph -TenantId $tenant -Scopes $scopes

# Optional: verify your directory role membership quickly (should show App Admin / Cloud App Admin)
# Get-MgMeMemberOf -DirectoryObjectId (Get-MgContext).Account | ? {$_.AdditionalProperties['@odata.type'] -like '*directoryRole*'} | ft

# --- Input: group display name that contains the target devices ---
$groepnaam = "🔒💻 Virtual Machines"

# Use a simple filter (no advanced OData search), so ConsistencyLevel header isn't needed
$group = Get-MgGroup -Filter "displayName eq '$groepnaam'" -Property "id,displayName" | Select-Object -First 1
if (-not $group) { throw "Group '$groepnaam' not found." }

# Build the target device group body
$tdg = [Microsoft.Graph.PowerShell.Models.MicrosoftGraphTargetDeviceGroup]::new()
$tdg.Id = $group.Id
$tdg.DisplayName = $group.DisplayName

# --- Service principals for AVD SSO ---
$msrdSpId = (Get-MgServicePrincipal -Filter "AppId eq 'a4a365df-50f1-4397-bc59-1a1564b8bb9c'").Id     # Microsoft Remote Desktop
$wclSpId  = (Get-MgServicePrincipal -Filter "AppId eq '270efc09-cd0d-444b-a71f-39af4910ec45'").Id     # Windows Cloud Login

# Enable Microsoft Entra authentication for RDP on both SPs if not enabled
foreach ($spId in @($msrdSpId, $wclSpId)) {
    $cfg = Get-MgServicePrincipalRemoteDesktopSecurityConfiguration -ServicePrincipalId $spId
    if (-not $cfg.IsRemoteDesktopProtocolEnabled) {
        Update-MgServicePrincipalRemoteDesktopSecurityConfiguration -ServicePrincipalId $spId -IsRemoteDesktopProtocolEnabled
    }
}

# Show current config/targets
#Get-MgServicePrincipalRemoteDesktopSecurityConfiguration -ServicePrincipalId $wclSpId
#Get-MgServicePrincipalRemoteDesktopSecurityConfigurationTargetDeviceGroup -ServicePrincipalId $wclSpId

# Create target device group (max 10 per SP)
New-MgServicePrincipalRemoteDesktopSecurityConfigurationTargetDeviceGroup -ServicePrincipalId $wclSpId -BodyParameter $tdg

Write-Host "✅ SSO target device group configured: $($group.DisplayName)" -ForegroundColor Green
