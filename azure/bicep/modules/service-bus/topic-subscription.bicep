/*
  Project:          Bicep kennissessie
  Created By:       Stefan Franke
  template version: 1.0
  Latest update:    03-05-2021
*/
param serviceBus object

resource serviceBus_name_serviceBus_topic_name_serviceBus_subscription_name 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2017-04-01' = {
  name: '${serviceBus.name}/${serviceBus.topic.name}/${serviceBus.subscription.name}'
  properties: {
    deadLetteringOnMessageExpiration: serviceBus.subscription.deadLetteringOnMessageExpiration
    deadLetteringOnFilterEvaluationExceptions: serviceBus.subscription.deadLetteringOnFilterEvaluationExceptions
    maxDeliveryCount: serviceBus.subscription.maxDeliveryCount
  }
  dependsOn: []
}
