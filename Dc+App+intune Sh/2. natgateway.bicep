param location string = 'westeurope'

resource natgatewaypublicip 'Microsoft.Network/publicIPAddresses@2025-05-01' = {
  name: 'AVD-NG-PIP'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static' 
  }
}

resource natgateway 'Microsoft.Network/natGateways@2025-05-01' = {
  name: 'AVD-NG'
  location: location
  sku: {
    name: 'Standard'
  }
   properties: {
     publicIpAddresses: [
       {
         id: natgatewaypublicip.id
       }
     ]
   }
}

output publicIp string = natgatewaypublicip.properties.ipAddress
