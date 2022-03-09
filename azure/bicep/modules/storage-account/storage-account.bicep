/*
  Project:          Bicep kennissessie
  Created By:       Stefan Franke
  template version: 1.0
  Latest update:    03-05-2021
*/

param general object = {
  location: resourceGroup().location
  tags: {
    LastUpdate: utcNow()
  }
}
@description('Properties of the storage accounts.')
param storageAccount object = {}

resource rsrc_storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccount.name
  location: general.location
  tags: general.tags
  sku: storageAccount.sku
  kind: storageAccount.kind
  properties: {
    networkAcls: storageAccount.properties.NetworkAcls
    supportsHttpsTrafficOnly: storageAccount.properties.supportsHttpsTrafficOnly
    isHnsEnabled: storageAccount.properties.isHnsEnabled
    accessTier: storageAccount.properties.accessTier
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    
  }
}
output storageAccount object  = {
  id: rsrc_storageAccount.id
  name: rsrc_storageAccount.name
}
output id string  = rsrc_storageAccount.id
output name string = rsrc_storageAccount.name
