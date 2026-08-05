param location string = 'westeurope'

param sanameprem string

resource saprem 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: sanameprem
  location: location
  properties: {
    allowSharedKeyAccess: true
    publicNetworkAccess: 'Disabled'
    minimumTlsVersion: 'TLS1_2'
  }
  sku: {
    name: 'PremiumV2_LRS'
  }
  kind: 'FileStorage'
}

resource fsprem 'Microsoft.Storage/storageAccounts/fileServices@2026-04-01' = {
  name: 'default'
  parent: saprem
}

resource fslogixshare 'Microsoft.Storage/storageAccounts/fileServices/shares@2026-04-01' = {
  name: 'fslogix'
  parent: fsprem
  properties: {
    enabledProtocols: 'SMB'
    shareQuota: 32
  }
}

output appdisk string = 'Let op: zet ad kerberos auth aan op het storage account en lees in de bicep code alle stappen die nodig zijn.'

// 1. stel kerberos auth in op storage account, alleen vinkje aanzetten is genoeg
// 2. stel default share level perms in op storage account smb contributor
// 3. grant admin concent op het storageaccount. Ga hiervoor naar alle app registraties en dan naar het desbetrefende storageaccount. Geef hierop admin concent
// 4. zorg ervoor dat je "kdc_enable_cloud_group_sids" tussen de tags zet in de manifest op de app registratie van het storage account. Meestal is dit nodig op een standaard azure file share
// 5. zorg ervoor dat avd/intune pc via het netwerk het storageaccount kan benaderen (ip whitelisting/private endpoint of over het hele internet aanzetten)
// 6. (supervision stap) zorg ervoor dat intune/avd kerberos tickets mogen accepteren. Maak hiervoor op intune (managed workplace apparaten) of gpo (avd) een cloud trust policy aan. Zorg ervoor dat de avd policy op alle ou’s ingesteld staat
