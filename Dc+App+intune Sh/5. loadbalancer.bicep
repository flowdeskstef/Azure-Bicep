param location string = 'westeurope'

param avdlbfe string = 'AVD-LB-FE'

param avdlb string = 'AVD-LB'

var avdfeId = resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', avdlb, avdlbfe)

resource avdlbpip 'Microsoft.Network/publicIPAddresses@2025-05-01' = {
  name: 'AVD-LB-PIP'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}           

resource lb 'Microsoft.Network/loadBalancers@2025-05-01' = {
  name: avdlb
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    frontendIPConfigurations: [
       {
        name: avdlbfe
        properties: {
          publicIPAddress: {
            id: avdlbpip.id
          }
        }
       }
    ]
    inboundNatRules: [
      // PublicIP:3389 -> app01:3389
      {
        name: 'dc01'
        properties: {
          frontendIPConfiguration: {
            id: avdfeId
          }
          protocol: 'Tcp'
          frontendPort: 3389
          backendPort: 3389
        }
      }
      // PublicIP:3390 -> app01:3389
      {
        name: 'app01'
        properties: {
          frontendIPConfiguration: {
            id: avdfeId
          }
          protocol: 'Tcp'
          frontendPort: 3390
          backendPort: 3389
        }
      }
      // PublicIP:3391 -> avd:3389
      {
        name: 'avd'
        properties: {
          frontendIPConfiguration: {
            id: avdfeId
          }
          protocol: 'Tcp'
          frontendPort: 3391
          backendPort: 3389
        }
      }
    ]
  }
}

output publicIp string = avdlbpip.properties.ipAddress
