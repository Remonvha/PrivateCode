/*
  Project:          Bicep kennissessie
  Created By:       Stefan Franke
  template version: 1.0
  Latest update:    03-05-2021
*/

param applicationInsights object
param functionApps array
param general object

//param serviceBus object

//Deploy Function Apps
module functionApp_module './modules//azure-function/function-app.bicep' = [for functionApp in functionApps:{
  name: 'FunctionApp-module-${functionApp.name}'
  params:{
    applicationInsights: applicationInsights
    functionApp: functionApp
    general: general
  }
}]

//Deploy Service Bus Authorization rule
// module serviceBusAuthRule_module './modules/service-bus/authorization-rule.bicep' = {
//   name: 'serviceBusAuthRule-module'
//   scope: resourceGroup('rg-shared-dev')
//   params:{
//     serviceBus: serviceBus
//   }
// }



