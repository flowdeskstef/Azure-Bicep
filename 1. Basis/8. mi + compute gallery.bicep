@description('Parameters for Image Gallery Definition')
param location string = 'westeurope'
param computeGalleryName string = 'AVD_GALLERY'
param imageDefinitionName string = 'W11_CI'
param publisher string = 'Microsoft'
param offer string = 'Windows11'
param sku string = 'latest'
param minRecommendedvCPUs int = 4
param maxRecommendedvCPUs int = 16
param minRecommendedMemory int = 16
param maxRecommendedMemory int = 64
param IsAcceleratedNetworkSupported string = 'true'
param IsHibernateSupported string = 'true'
param DiskControllerTypes string = 'NVMe'

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: 'AVD-MI'
  location: location
}

resource computegallery 'Microsoft.Compute/galleries@2025-03-03' = {
  name: computeGalleryName
  location: location
}

resource galleryNameImageDefinition 'Microsoft.Compute/galleries/images@2025-03-03' = {
  parent: computegallery
  name: imageDefinitionName
  location: location
  properties: {
    osType: 'Windows'
    osState: 'Generalized'
    identifier: {
      publisher: publisher
      offer: offer
      sku: sku
    }
    recommended: {
      vCPUs: {
        min: minRecommendedvCPUs
        max: maxRecommendedvCPUs
      }
      memory: {
        min: minRecommendedMemory
        max: maxRecommendedMemory
      }
    }
    hyperVGeneration: 'V2'
    features: [
      {
        name: 'IsAcceleratedNetworkSupported'
        value: IsAcceleratedNetworkSupported
      }
      
  {
    name: 'IsHibernateSupported'
    value: IsHibernateSupported
  }
  {
    name: 'DiskControllerTypes'
    value: DiskControllerTypes
  }
    ]
    architecture: 'x64'
  }
}
