@description('RG waar de netwerkresources staan (bijv. RG-INFRA)')
param networkRgName string = 'RG-INFRA'

@description('Naam van het bestaande VNet in de network RG')
param vnetName string = 'AVD-network'

@description('Naam van het servers-subnet in het VNet')
param serversSubnetName string = 'subnet-servers'

@description('Naam van de bestaande Load Balancer in de network RG')
param lbName string = 'avd-lb'

//parameters credentials accounts
param domainuser string
@secure()
param domainpwd string

param applocuser string
@secure()
param applocpwd string

//west europe location
param location string = 'westeurope'

//app vm sku
param appsku string = 'Standard_D2as_v6'
//app disk snelheid, standard disk
param apposDiskSku string = 'StandardSSD_LRS'

//dc vm sku
param dcsku string = 'Standard_b2als_v2'
//dc disk snelheid, standard disk
param dcosDiskSku string = 'StandardSSD_LRS'

//dc private ip, volgens ons default subnet template de eerste in de servers reeks (10.10.1.0/24)
param dcPrivateIp string = '10.10.1.4'
param appPrivateIp string = '10.10.1.5'

//////////////////////////////////
////niets aanpassen hieronder///
//////////////////////////////

//import vnets
resource vnet 'Microsoft.Network/virtualNetworks@2025-05-01' existing = {
  scope: resourceGroup(networkRgName)
  name:  vnetName
}

resource subnetservers 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' existing = {
  name:  serversSubnetName
  parent: vnet
  // scope erft mee van parent (vnet)
}

var dcNatRuleId  = resourceId(networkRgName, 'Microsoft.Network/loadBalancers/inboundNatRules', lbName, 'dc01')
var appNatRuleId = resourceId(networkRgName, 'Microsoft.Network/loadBalancers/inboundNatRules', lbName, 'app01')

// dc nic
resource dcnic 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: 'dc01-nic'
  location: location
  properties: {
    enableAcceleratedNetworking: true
    ipConfigurations: [
     {
      name: 'ipconfig1'
      properties: {
        privateIPAddress: dcPrivateIp
        privateIPAllocationMethod: 'Static'
        subnet: {
          id: subnetservers.id
        }
        loadBalancerInboundNatRules: [
           {
            id: dcNatRuleId
           }
        ]
      }
     }
    ]
  }
}

//app nic
resource appnic 'Microsoft.Network/networkInterfaces@2025-05-01' = {
  name: 'app01-nic'
  location: location
  properties: {
    enableAcceleratedNetworking: true
    ipConfigurations: [
     {
      name: 'ipconfig1'
      properties: {
        privateIPAddress: appPrivateIp
        privateIPAllocationMethod: 'Static'
        subnet: {
          id: subnetservers.id
        }
        loadBalancerInboundNatRules: [
           {
            id: appNatRuleId
           }
        ]
      }
     }
    ]
  }
}

//dc01 vm
resource dcvm 'Microsoft.Compute/virtualMachines@2025-11-01' = {
  name: 'dc01'
  location: location
   properties: {
     hardwareProfile: {
       vmSize: dcsku
     }
      osProfile: {
        computerName: 'dc01'
        adminUsername: domainuser
        adminPassword: domainpwd
      }
       storageProfile: {
         imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer: 'WindowsServer'
          sku: '2025-datacenter-azure-edition-smalldisk'
          version: 'latest'
         }
         osDisk: {
          caching: 'ReadWrite'
          name: 'dc01-osdisk'
          diskSizeGB: 64
          createOption: 'FromImage'
          managedDisk: {
            storageAccountType: dcosDiskSku
          }
         }
       }
       networkProfile: {
         networkInterfaces: [
           {
            id: dcnic.id
           }
         ]
       }
       diagnosticsProfile: {
        bootDiagnostics: {
          enabled: true
        }
       }
       securityProfile: {
        securityType: 'TrustedLaunch'
        uefiSettings: {
          secureBootEnabled: true
          vTpmEnabled: true
        }
       }
   }
}

//app vm
resource appvm 'Microsoft.Compute/virtualMachines@2025-11-01' = {
  name: 'app01'
  zones: [
    '1'
  ]
  location: location
   properties: {
    licenseType: 'Windows_Server' 
    hardwareProfile: {
       vmSize: appsku
     }
      osProfile: {
        computerName: 'app01'
        adminUsername: applocuser
        adminPassword: applocpwd
      }
       storageProfile: {
         imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer: 'WindowsServer'
          sku: '2025-datacenter-azure-edition-smalldisk'
          version: 'latest'
         }
         osDisk: {
          caching: 'ReadWrite'
          name: 'app01-osdisk'
          diskSizeGB: 64
          createOption: 'FromImage'
          managedDisk: {
            storageAccountType: apposDiskSku
          }
         }
         dataDisks: [
          {
            createOption: 'Empty'
            lun: 0
            name: 'app01-ApplicationDataDisk'
            diskSizeGB: 32
            managedDisk: {
              storageAccountType: 'PremiumV2_LRS'
            }
          }
         ]
       }
       networkProfile: {
         networkInterfaces: [
           {
            id: appnic.id
           }
         ]
       }
       diagnosticsProfile: {
        bootDiagnostics: {
          enabled: true
        }
       }
       securityProfile: {
        securityType: 'TrustedLaunch'
        uefiSettings: {
          secureBootEnabled: true
          vTpmEnabled: true
        }
       }
   }
}

output dc string = 'Let op: zorg ervoor dat je dc aan het domein koppelt en ad cloud sync configureerd'
