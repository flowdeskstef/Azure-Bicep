param location string = 'westeurope'

@description('originele datum van het image die hij pakt om het image te updaten')
param imgverold string

@description('datum van vandaag')
param imgvernew string

param diskSize int = 127
param vmSize string = 'Standard_D8as_v6'

@description('RG waar de netwerkresources staan (bijv. RG-INFRA)')
param networkRgName string = 'avd'

// naam is "W11_CI"
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
param stagingRgName string = 'RG-Staging-update'

var stagingRgId = '/subscriptions/${subscription().subscriptionId}/resourceGroups/${stagingRgName}'

// Include the customizations module
module customizationsModule '13.1 customize-update.bicep' = {
  name: 'customizationsModule'
}

resource imageTemplates_name_resource 'Microsoft.VirtualMachineImages/imageTemplates@2024-02-01' = {
  name: imgvernew
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedIdentity.id}': {}
    }
  }
  properties: {
    source: {
      type: 'SharedImageVersion'
      imageVersionId: resourceId('Microsoft.Compute/galleries/images/versions', avdimagegallery.name, imagedef.name, imgverold)
    }

    distribute: [
      {
        excludeFromLatest: false
        galleryImageId: resourceId('Microsoft.Compute/galleries/images/versions', avdimagegallery.name, imagedef.name, imgvernew)
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
