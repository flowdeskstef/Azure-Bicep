param location string = 'westeurope'
param klantnaam string
param tenantid string

param localAdminUsername string
@secure()
param localAdminPassword string

resource keyvault 'Microsoft.KeyVault/vaults@2025-05-01' = {
  name: 'AVD-${klantnaam}-KV'
  location: location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: tenantid
    enableRbacAuthorization: true
    publicNetworkAccess: 'Enabled'
    enabledForDeployment: true
    enabledForDiskEncryption:true
    enabledForTemplateDeployment: true
  }
}

resource localAdminUserSecret 'Microsoft.KeyVault/vaults/secrets@2025-05-01' = {
  name: 'localadmin-username'
  parent: keyvault
  properties: {
    value: localAdminUsername
  }
}

resource localAdminPasswordSecret 'Microsoft.KeyVault/vaults/secrets@2025-05-01' = {
  name: 'localadmin-password'
  parent: keyvault
  properties: {
    value: localAdminPassword
  }
}
// testbestand
