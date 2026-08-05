targetScope = 'subscription'

resource customRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' = {
  name: guid(subscription().id, 'Custom_Images')
  properties: {
    roleName: 'Custom_Images'
    description: ''
    type: 'CustomRole'
    permissions: [
      {
        actions: [
          'Microsoft.Compute/galleries/read'
          'Microsoft.Compute/galleries/images/read'
          'Microsoft.Compute/galleries/images/versions/read'
          'Microsoft.Compute/galleries/images/versions/write'
          'Microsoft.Compute/images/write'
          'Microsoft.Compute/images/read'
          'Microsoft.Compute/images/delete'
          'Microsoft.Network/virtualNetworks/read'
          'Microsoft.Network/virtualNetworks/subnets/join/action'
          'Microsoft.ContainerInstance/register/action'
        ]
        notActions: []
        dataActions: []
        notDataActions: []
      }
    ]
    assignableScopes: [
      subscription().id
    ]
  }
}

output custom_images string = 'Let op: maak nu een custom image template aan op avd. Dit kan nog niet via bicep op dit moment. Maak vervolgens de build voordat je verder gaat naar 10. avd'

// C:\Users\%username%\OneDrive - flowdesk\Gedeelde documenten - DATA\Algemeen\Technisch\Azure Virtual Desktop\Algemeen\1. handleidingen\custom image templates.docx 
