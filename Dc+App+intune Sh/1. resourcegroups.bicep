targetScope = 'subscription'

param location string = 'westeurope'

resource rginfra 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'RG-INFRA'
  location: location
}

resource rgstorage 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'RG-STORAGE'
  location: location
}

resource rgavd 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'RG-AVD'
  location: location
}

resource rgcompute 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: 'RG-COMPUTE'
  location: location
}

