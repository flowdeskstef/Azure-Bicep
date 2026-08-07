////////params/////

param location string = 'westeurope'

param storagerg string = 'RG-STORAGE'

resource vnet 'Microsoft.Network/virtualNetworks@2025-05-01' existing = {
  name: 'AVD-Network'
}

resource subnetpe 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' existing = {
  name: 'Subnet-PE'
  parent: vnet
}

param sanameprem string

resource saprem 'Microsoft.Storage/storageAccounts@2026-04-01' existing = {
  name: sanameprem
  scope: resourceGroup(storagerg)
}

/////private dns zone azure////////

var privateDnsZoneName = 'privatelink.file.${environment().suffixes.storage}' // -> privatelink.file.core.windows.net

resource privdnszone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZoneName
  location: 'global'
}

/* Link the Private DNS zone to the VNet for name resolution */
resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  name: 'link-${uniqueString(vnet.id)}'
  parent: privdnszone
  location: 'global'
  properties: {
    registrationEnabled: false   // registration isn’t used for PEs
    virtualNetwork: {
      id: vnet.id
    }
  }
}

////////////prem sa///////

resource privendpointprem 'Microsoft.Network/privateEndpoints@2025-05-01' = {
  name: 'PE-DataPREM'
  location: location
  dependsOn: [
    vnetLink
  ]
  properties: {
    customNetworkInterfaceName: 'PE-DataPREM-nic'
    privateLinkServiceConnections: [
        {
         name: 'pep-${sanameprem }-file-conn'
         properties: {
          privateLinkServiceId: saprem.id
          groupIds: [
            'file'
          ]
         }
        }
    ]
    subnet: {
      id: subnetpe.id
    }
  }
}

resource privdnszonegrpprem 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2025-05-01' = {
  name: 'default'
  parent: privendpointprem
  properties: {
    privateDnsZoneConfigs: [
       {
        name: 'files'
        properties: {
          privateDnsZoneId: privdnszone.id
        }
       }
    ]
  }
}
