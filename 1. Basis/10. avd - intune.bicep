//
// --- Host Pool naming ---
//

param location string = 'westeurope'
param hostPoolName string = 'AVD-HostPool'
param workspaceName string
param desktopAppGroupName string = 'Online-Werkplek'

//
// --- Session host infra parameters ---
//

param networkrg string = 'RG-INFRA'

resource vnet 'Microsoft.Network/virtualNetworks@2025-05-01' existing = {
  name: 'AVD-Network'
  scope: resourceGroup(networkrg)
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' existing = {
  name: 'Subnet-SessionHosts'
  parent: vnet
}

//
// --- Session host config parameters ---
//

@description('Resource group name where session host VMs will live')
param sessionHostRgName string = 'RG-COMPUTE'
@description('VM name prefix (hosts will be named <prefix>-0001, etc.)')
param vmNamePrefix string = 'avd-sh'
@description('VM size SKU (e.g., Standard_D4s_v5)')
param vmSizeId string = 'Standard_D8as_v7'

//
// --- Image gallery parameters ---
//

param gallerySubscriptionId string = subscription().subscriptionId

@description('Resource group of the gallery')
param galleryResourceGroup string = 'RG-AVD'

@description('Gallery name')
param galleryName string = 'AVD_GALLERY'

@description('Image definition name')
param galleryImageDefinitionName string = 'W11_CI'

@description('Image version (e.g., 1.0.2025.0901)')
param galleryImageVersion string

// Optional: declare existing resource to catch typos at compile/validation
resource imageVersion 'Microsoft.Compute/galleries/images/versions@2025-03-03' existing = {
  name: '${galleryName}/${galleryImageDefinitionName}/${galleryImageVersion}'
  scope: resourceGroup(gallerySubscriptionId, galleryResourceGroup)
}

// Use its id to be 100% correct
var galleryImageVersionId = imageVersion.id

//
// --- vm local admin creds keyvault ---
//

@description('Name of the Key Vault that holds the local admin secrets')
param klantnaaminkeyvault string

@description('Secret name: local admin username')
param localAdminUserSecretName string = 'localadmin-username'

@description('Secret name: local admin password')
param localAdminPassSecretName string = 'localadmin-password'

resource kv 'Microsoft.KeyVault/vaults@2025-05-01' existing = {
  name:  'AVD-${klantnaaminkeyvault}-KV'
}

var localAdminUsernameSecretUri = '${kv.properties.vaultUri}secrets/${localAdminUserSecretName}'
var localAdminPasswordSecretUri = '${kv.properties.vaultUri}secrets/${localAdminPassSecretName}'

// Entra ID join (if joinType = AzureActiveDirectory)
@description('MDM provider GUID (if Entra ID join)')
param tenantid string

resource mi 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = {
  name: 'AVD-MI'
}

// -------------------------------------------------------------

resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2026-01-01-preview' ={
  name: hostPoolName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${mi.id}': {}
    }
  }
  properties: {
    friendlyName: hostPoolName
    hostPoolType: 'Pooled'
    loadBalancerType: 'BreadthFirst'
    preferredAppGroupType: 'Desktop'
    managementType: 'Automated' // <- automated/session-host-config approach
    maxSessionLimit: 10
    startVMOnConnect: false
    publicNetworkAccess: 'Enabled'
    validationEnvironment: false
    directUDP: 'Enabled'
    managedPrivateUDP: 'Enabled'
    relayUDP: 'Enabled'
    publicUDP: 'Enabled'
    customRdpProperty: 'drivestoredirect:s:*;usbdevicestoredirect:s:*;targetisaadjoined:i:1;redirectclipboard:i:1;redirectprinters:i:0;audiomode:i:0;videoplaybackmode:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:1;enablerdsaadauth:i:1;audiocapturemode:i:1;encode redirected video capture:i:1;redirected video capture encoding quality:i:2;camerastoredirect:s:*'
  }
}

// What to build: image, size, network, join, credentials, etc.
resource shConfig 'Microsoft.DesktopVirtualization/hostPools/sessionHostConfigurations@2026-01-01-preview' = {
  name: 'default'
  parent: hostPool
  properties: {
      vmLocation: location
      vmResourceGroup: sessionHostRgName
      vmNamePrefix: vmNamePrefix
      vmSizeId: vmSizeId
      securityInfo: {
        secureBootEnabled: true
        type: 'TrustedLaunch'
        vTpmEnabled: true
       }
      networkInfo: {
        subnetId: subnet.id
      }
      diskInfo: {
        managedDisk: {
           type: 'Premium_LRS'
        }
      }
      vmAdminCredentials: {
        usernameKeyVaultSecretUri: localAdminUsernameSecretUri
        passwordKeyVaultSecretUri: localAdminPasswordSecretUri
      }
      imageInfo: {
       type: 'Custom'
        customInfo: {
          resourceId: galleryImageVersionId
        }
      }
      domainInfo: {
        joinType:  'AzureActiveDirectory'
        azureActiveDirectoryInfo: {
          mdmProviderGuid: tenantid
        }     
      }
 }
}

resource shmngt 'Microsoft.DesktopVirtualization/hostPools/sessionHostManagements@2026-01-01-preview' = {
  name: 'default'
  parent: hostPool
  properties: {
    scheduledDateTimeZone: 'W. Europe Standard Time'
    update: {
      logOffDelayMinutes: 2
      maxVmsRemoved: 1
      logOffMessage: 'Je wordt binnenkort uitgelogd.'    
      deleteOriginalVm: true
    }
  }
}

// Desktop Application Group bound to the host pool
resource desktopAg 'Microsoft.DesktopVirtualization/applicationGroups@2026-01-01-preview' = {
  name: desktopAppGroupName
  location: location
  properties: {
    applicationGroupType: 'Desktop'
    hostPoolArmPath: hostPool.id
    friendlyName: desktopAppGroupName
  }
}

// Workspace that references the desktop AG
resource workspace 'Microsoft.DesktopVirtualization/workspaces@2026-01-01-preview' = {
  name: workspaceName
  location: location
  properties: {
    friendlyName: workspaceName
    applicationGroupReferences: [
      desktopAg.id
    ]
  }
}

output rechten string = 'Zet vinkje join session host to intune aan in de portal!'
