param location string = 'westeurope'

resource natgateway 'Microsoft.Network/natGateways@2025-05-01' existing = {
  name: 'AVD-NG'
}

resource nsgsessionhosts 'Microsoft.Network/networkSecurityGroups@2025-05-01' existing = {
  name: 'NSG-SessionHosts'
}

resource nsgpe 'Microsoft.Network/networkSecurityGroups@2025-05-01' existing = {
  name: 'NSG-PE'
}

resource vnet 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: 'AVD-Network'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    subnets: [
       {
        name: 'Subnet-SessionHosts'
        properties: {
           addressPrefix: '10.10.2.0/24'
           defaultOutboundAccess: false
           privateLinkServiceNetworkPolicies: 'Disabled'
           networkSecurityGroup: {
            id: nsgsessionhosts.id
           }
           natGateway: {
            id: natgateway.id
           }
        }
       }
       {
        name: 'Subnet-PE'
        properties: {
           addressPrefix: '10.10.0.0/24'
           defaultOutboundAccess: false
           networkSecurityGroup: {
            id: nsgpe.id
           }
        }
       }
    ]
  }
}
