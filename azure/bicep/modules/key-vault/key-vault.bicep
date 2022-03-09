param general object = {
  location: resourceGroup().location
  tags: {
    LastModifiedDate: utcNow()
    Project: '<<project-name>>'
  }
}

@description('Properties of the Key Vault instance, dedicated for secrets and certificates.')
@secure()
param keyVault object = {
  administratorObjectId: '<<admin-object-id>>'
  name: '<<key-vault-name>>'
}

resource keyVault_name 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyVault.name
  location: general.location
  tags: general.tags
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: keyVault.administratorObjectId
        permissions: {
          keys: [
            'get'
            'list'
            'update'
            'create'
            'import'
            'delete'
            'recover'
            'backup'
            'restore'
          ]
          secrets: [
            'get'
            'list'
            'set'
            'delete'
            'recover'
            'backup'
            'restore'
          ]
          certificates: [
            'get'
            'list'
            'update'
            'create'
            'import'
            'delete'
            'recover'
            'backup'
            'restore'
            'managecontacts'
            'manageissuers'
            'getissuers'
            'listissuers'
            'setissuers'
            'deleteissuers'
          ]
        }
      }
    ]
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    enableSoftDelete: true
  }
}