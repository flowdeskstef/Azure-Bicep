param location string = 'westeurope'

param imageTemplates_name string

@description('wat is de datum van vandaag? bvb 25.09.25')
param imgver string

param diskSize int = 127
param vmSize string = 'Standard_D8as_v7'

@description('RG waar de netwerkresources staan (bijv. RG-INFRA)')
param networkRgName string = 'RG-INFRA'

resource imagedef 'Microsoft.Compute/galleries/images@2024-03-03' existing = {
  name: 'W11_CI'
  parent: avdimagegallery
}

//import vnets
resource vnet 'Microsoft.Network/virtualNetworks@2024-07-01' existing = {
  scope: resourceGroup(networkRgName)
  name:  'AVD-network'
}

//import subnet
resource subnetsessinhosts 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' existing = {
  name: 'subnet-sessionhosts'
  parent: vnet
}

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = {
  name: 'AVD-MI'
}

resource avdimagegallery 'Microsoft.Compute/galleries@2024-03-03' existing = {
  name: 'AVD_GALLERY'
}

@description('Naam van de staging resource group voor Azure Image Builder (AIB).')
param stagingRgName string = 'RG-Staging'

var stagingRgId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${stagingRgName}'

// Include the customizations module
module customizationsModule '09.1 customize.bicep' = {
  name: 'customizationsModule'
}

resource imageTemplates_name_resource 'Microsoft.VirtualMachineImages/imageTemplates@2024-02-01' = {
  name: imageTemplates_name
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentity.id}': {}
    }
  }
  properties: {

    source: {
      type: 'PlatformImage'
      publisher: 'microsoftwindowsdesktop'
      offer: 'windows-11'
      sku: 'win11-25h2-avd'
      version: 'latest'
    }

    distribute: [
      {
        excludeFromLatest: false
        galleryImageId: resourceId('Microsoft.Compute/galleries/images/versions', avdimagegallery.name, imagedef.name, imgver)
        replicationRegions: [
          location
        ]
        runOutputName: 'Output'
        type: 'SharedImage'
      }
    ]
    
    vmProfile: {
      osDiskSizeGB: diskSize
      vmSize: vmSize
      vnetConfig: {
        subnetId: subnetsessinhosts.id
      }
    }

    stagingResourceGroup: stagingRgId

    customize: customizationsModule.outputs.customizationsOutput

  }
}
output build string = 'start de build nu in de azure portal en pak wat popcorn. Zal waarschijnlijk een aantal uur duren voordat het image klaar is'
