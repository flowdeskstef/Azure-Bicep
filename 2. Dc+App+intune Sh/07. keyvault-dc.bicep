param location string = 'westeurope'
param klantnaam string
param tenantid string

param localAdminUsername string
@secure()
param localAdminPassword string
param DomainAdminUsername string
@secure()
param DomainAdminPassword string

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

resource domainAdminUsernameSecret 'Microsoft.KeyVault/vaults/secrets@2025-05-01' = {
  name: 'domainadmin-username'
  parent: keyvault
  properties: {
    value: DomainAdminUsername
  }
}

resource domainAdminPasswordSecret 'Microsoft.KeyVault/vaults/secrets@2025-05-01' = {
  name: 'domainadmin-password'
  parent: keyvault
  properties: {
    value: DomainAdminPassword
  }
}
