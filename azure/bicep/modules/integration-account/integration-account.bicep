param general object
param integrationAccount object
@secure()
param storageAccountCICD object
param keyVault object

resource integrationAccount_resource 'Microsoft.Logic/integrationAccounts@2019-05-01' = {
  name: integrationAccount.name
  location: integrationAccount.location
  properties: {
  }
  tags: general.tags
  sku: {
    name: integrationAccount.sku
  }
  dependsOn: []
}

resource ia_partners 'Microsoft.Logic/integrationAccounts/partners@2019-05-01' = [for partner in integrationAccount.partners: {
  name: '${integrationAccount.name}/${partner.name}'
  properties: partner.properties
  dependsOn: [
    integrationAccount_resource
  ]
}]

resource ia_agreements 'Microsoft.Logic/integrationAccounts/agreements@2019-05-01' = [for agreement in integrationAccount.agreements: {
  name: '${integrationAccount.name}/${agreement.name}'
  properties: agreement.properties
  dependsOn: [
    integrationAccount_resource
    ia_certificate
    ia_certificatep
    ia_partners
  ]
}]

// No maps yet
// resource ia_maps 'Microsoft.Logic/integrationAccounts/maps@2019-05-01' = [for map in integrationAccount.maps: {
//   name: '${integrationAccount.name}/${map.name}'
//   properties: {
//     mapType: map.properties.mapType
//     parametersSchema: map.properties.parametersSchema
//     contentType: map.properties.contentType
//     contentLink: {
//       uri: '${storageAccountCICD.url}/integration-account/maps/${map.name}${storageAccountCICD.sasToken}'
//       contentVersion: '1.0.0.0'
//     }
//   }
//   dependsOn: [
//     integrationAccount_resource
//   ]
// }]

resource ia_schemas 'Microsoft.Logic/integrationAccounts/schemas@2019-05-01' = [for schema in integrationAccount.schemas: {
  name: '${integrationAccount.name}/${schema.name}'
  properties: {
    schemaType: schema.properties.schemaType
    documentName: schema.properties.documentName
    contentLink: {
      uri: '${storageAccountCICD.url}/schemas/${schema.name}${storageAccountCICD.sasToken}'
      contentVersion: '1.0.0.0'
    }
    contentType: schema.properties.contentType
  }
  dependsOn: [
    integrationAccount_resource
  ]
}]

resource ia_certificatep 'Microsoft.Logic/integrationAccounts/certificates@2019-05-01' = [ for certp in integrationAccount.certificatesp : {
  name: '${integrationAccount.name}/${certp.name}'
  properties: {
    key: {
      keyVault: {
        name: keyVault.name
        id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.KeyVault/vaults/${keyVault.name}'
        type: 'Microsoft.KeyVault/vaults'
      }
      keyName: certp.properties.key.keyName
    }
    publicCertificate: certp.properties.publicCertificate
  }
  dependsOn: [
    integrationAccount_resource
  ]
}]

resource ia_certificate 'Microsoft.Logic/integrationAccounts/certificates@2019-05-01' = [for cert in integrationAccount.certificates :{
  name: '${integrationAccount.name}/${cert.name}'
  properties: cert.properties
  dependsOn: [
    integrationAccount_resource
  ]
}]
