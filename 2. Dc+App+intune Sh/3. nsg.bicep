param location string = 'westeurope'

@description('Lijst met kantoor CIDRs die RDP (3389) mogen.')
var officeIps = [
  '64.26.44.33/32'
  '84.246.12.133/32'
]

resource nsgServers 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: 'NSG-Servers'
  location: location
}

resource nsgSessionHosts 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: 'NSG-SessionHosts'
  location: location
}

resource nsgPe 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: 'NSG-PE'
  location: location
}

resource nsgServersRuleOffice 'Microsoft.Network/networkSecurityGroups/securityRules@2025-05-01' = {
  name: 'Allow-RDP-Flowdesk'
  parent: nsgServers
  properties: {
    access: 'Allow'
    direction: 'Inbound'
    priority: 100
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '3389'
    sourceAddressPrefixes: officeIps
    destinationAddressPrefix: '*'
  }
}

resource nsgSessionHostsRuleOffice 'Microsoft.Network/networkSecurityGroups/securityRules@2025-05-01' = {
  name: 'Allow-RDP-Flowdesk'
  parent: nsgSessionHosts
  properties: {
    access: 'Allow'
    direction: 'Inbound'
    priority: 100
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '3389'
    sourceAddressPrefixes: officeIps
    destinationAddressPrefix: '*'
  }
}
