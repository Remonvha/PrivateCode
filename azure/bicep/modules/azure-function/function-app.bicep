/*
  Project:          Bicep kennissessie
  Created By:       Stefan Franke
  template version: 1.0
  Latest update:    03-05-2021
*/

param functionApp object
param applicationInsights object
param general object = {
  location: resourceGroup().location
  tags: {
    LastUpdate: utcNow()
  }
}

resource rsrc_storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: functionApp.storageAccount.name
  location: general.location
  tags: general.tags
  sku: functionApp.storageAccount.sku
  kind: functionApp.storageAccount.kind
  properties: {
    networkAcls: functionApp.storageAccount.properties.NetworkAcls
    supportsHttpsTrafficOnly: functionApp.storageAccount.properties.supportsHttpsTrafficOnly
    isHnsEnabled: functionApp.storageAccount.properties.isHnsEnabled
    accessTier: functionApp.storageAccount.properties.accessTier
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

resource functionApp_appServicePlan 'Microsoft.Web/serverfarms@2018-02-01' = {
  name: functionApp.appServicePlan.name
  location: general.location
  tags: general.tags
  sku: functionApp.appServicePlan.sku
}

resource functionApp_name 'Microsoft.Web/sites@2018-11-01' = {
  name: functionApp.name
  location: general.location
  tags: general.tags
  kind: 'functionapp'
  dependsOn:[]
  properties: {
    serverFarmId: functionApp_appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${rsrc_storageAccount.name};AccountKey=${listKeys(rsrc_storageAccount.id, '2015-05-01-preview').key1}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${rsrc_storageAccount.name};AccountKey=${listKeys(rsrc_storageAccount.id, '2015-05-01-preview').key1}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionApp.name)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: reference(resourceId(applicationInsights.resourceGroup,'Microsoft.Insights/components', applicationInsights.name), '2014-04-01').InstrumentationKey
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
    }
  }
}
