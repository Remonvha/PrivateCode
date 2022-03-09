/*
  Project:          Bicep kennissessie
  Created By:       Stefan Franke
  template version: 1.0
  Latest update:    03-05-2021
*/
param serviceBus object

resource serviceBus_name_serviceBus_authorizationRule_name 'Microsoft.ServiceBus/namespaces/AuthorizationRules@2017-04-01' = {
  name: '${serviceBus.name}/${serviceBus.authorizationRule.name}'
  properties: {
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
  dependsOn: []
}
