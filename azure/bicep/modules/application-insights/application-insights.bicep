param applicationInsights object = {
  name: '<<application-insights-name>>'
}
param general object = {
  location: resourceGroup().location
  tags: {
    LastModifiedDate: utcNow()
    Project: '<<project-name>>'
  }
}

resource applicationInsights_name 'microsoft.insights/components@2018-05-01-preview' = {
  name: applicationInsights.name
  location: general.location
  tags: general.tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Redfield'
    Request_Source: 'IbizaAIExtension'
    RetentionInDays: 90
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}