@description('Properties of the API Management instance')
param apiManagement object = {
  name: '<<api-management-name>>'
  resourceGroup: '<<resourceGroup>>'
}

@description('Properties of the Application Insights instance')
param applicationInsights object = {
  name: '<<application-insights-name>>'
  resourceGroup: '<<resourceGroup>>'
}

@description('Properties of the Platform Dashboard.')
param dashboardPlatform object = {
  name: '<<name>>'
  hidden_title: '<<hidden_title>>'
}

@description('Gets or sets a list of general key value pairs that describe the resource.')
param general object = {
  customerName: '<<customerName>>'
  env: '<<env>>'
  location: '<<location>>'
}

@description('Properties of the Key Vault instance, dedicated for secrets and certificates.')
param keyVault object = {
  name: '<<key-vault-name>>'
  resourceGroup: '<<resourceGroup>>'
}

@description('Properties of the Log Analytics Workspace.')
param logAnalytics object = {
  name: '<<log-analytics-name>>'
  resourceGroup: '<<resourceGroup>>'
}

@description('Properties of the  Storage Account.')
param storageAccount object = {
  name: '<<name>>'
  resourceGroup: '<<resourceGroup>>'
}

resource dashboardPlatform_name 'Microsoft.Portal/dashboards@2019-01-01-preview' = {
  location: general.location
  name: dashboardPlatform.name
  properties: {
    lenses: {
      '0': {
        order: 0
        parts: {
          '0': {
            position: {
              x: 0
              y: 0
              rowSpan: 1
              colSpan: 2
            }
            metadata: {
              inputs: [
                {
                  name: 'id'
                  value: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${logAnalytics.resourceGroup}/providers/Microsoft.OperationalInsights/workspaces/${logAnalytics.name}'
                }
              ]
              type: 'Extension/Microsoft_OperationsManagementSuite_Workspace/PartType/WorkspacePart'
            }
          }
          '1': {
            position: {
              x: 2
              y: 0
              rowSpan: 1
              colSpan: 2
            }
            metadata: {
              inputs: [
                {
                  name: 'id'
                  value: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${applicationInsights.resourceGroup}/providers/microsoft.insights/components/${applicationInsights.name}'
                }
                {
                  name: 'Version'
                  value: '1.0'
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/AspNetOverviewPinnedPart'
            }
          }
          '2': {
            position: {
              x: 4
              y: 0
              rowSpan: 1
              colSpan: 2
            }
            metadata: {
              inputs: [
                {
                  name: 'id'
                  value: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${apiManagement.resourceGroup}/providers/Microsoft.ApiManagement/service/${apiManagement.name}'
                }
              ]
              type: 'Extension/Microsoft_Azure_ApiManagement/PartType/ServicePart'
            }
          }
          '3': {
            position: {
              x: 6
              y: 0
              rowSpan: 1
              colSpan: 2
            }
            metadata: {
              inputs: [
                {
                  name: 'id'
                  value: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${keyVault.resourceGroup}/providers/Microsoft.KeyVault/vaults/${keyVault.name}'
                }
              ]
              type: 'Extension/Microsoft_Azure_KeyVault/PartType/VaultPart'
            }
          }
          '4': {
            position: {
              x: 8
              y: 0
              rowSpan: 1
              colSpan: 2
            }
            metadata: {
              inputs: [
                {
                  name: 'id'
                  value: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${storageAccount.resourceGroup}/providers/Microsoft.Storage/storageAccounts/${storageAccount.name}'
                  isOptional: true
                }
                {
                  name: 'resourceId'
                  isOptional: true
                }
                {
                  name: 'menuid'
                  isOptional: true
                }
              ]
              type: 'Extension/HubsExtension/PartType/ResourcePart'
            }
          }
          '5': {
            position: {
              x: 12
              y: 0
              rowSpan: 8
              colSpan: 5
            }
            metadata: {
              inputs: [
                {
                  name: 'resourceGroup'
                  isOptional: true
                }
                {
                  name: 'id'
                  value: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${general.nameSharedResourceGroup}'
                  isOptional: true
                }
              ]
              type: 'Extension/HubsExtension/PartType/ResourceGroupMapPinnedPart'
            }
          }
          '6': {
            position: {
              x: 0
              y: 1
              rowSpan: 3
              colSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  value: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${apiManagement.resourceGroup}/providers/Microsoft.ApiManagement/service/${apiManagement.name}'
                          }
                          name: 'Requests'
                          aggregationType: 1
                          namespace: 'microsoft.apimanagement/service'
                          metricVisualization: {
                            displayName: 'Requests'
                            resourceDisplayName: ' '
                          }
                        }
                      ]
                      title: 'Gateway requests'
                      titleKind: 2
                      visualization: {
                        chartType: 2
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                      }
                      grouping: {
                        dimension: 'GatewayResponseCodeCategory'
                      }
                    }
                  }
                  isOptional: true
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
              settings: {}
              filters: {}
            }
          }
          '7': {
            position: {
              x: 4
              y: 1
              rowSpan: 3
              colSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  value: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${apiManagement.resourceGroup}/providers/Microsoft.ApiManagement/service/${apiManagement.name}'
                          }
                          name: 'Requests'
                          aggregationType: 1
                          namespace: 'microsoft.apimanagement/service'
                          metricVisualization: {
                            displayName: 'Requests'
                            resourceDisplayName: ' '
                          }
                        }
                      ]
                      title: 'Gateway errors'
                      titleKind: 2
                      visualization: {
                        chartType: 2
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                      }
                      filterCollection: {
                        filters: [
                          {
                            key: 'LastErrorReason'
                            operator: 1
                            values: [
                              'none'
                            ]
                          }
                        ]
                      }
                      grouping: {
                        dimension: 'LastErrorReason'
                      }
                    }
                  }
                  isOptional: true
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
              settings: {}
              filters: {}
            }
          }
          '8': {
            position: {
              x: 8
              y: 1
              rowSpan: 3
              colSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  value: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${apiManagement.resourceGroup}/providers/Microsoft.ApiManagement/service/${apiManagement.name}'
                          }
                          name: 'Duration'
                          aggregationType: 4
                          namespace: 'microsoft.apimanagement/service'
                          metricVisualization: {
                            displayName: 'Overall Duration of Gateway Requests'
                            resourceDisplayName: ' '
                          }
                        }
                      ]
                      title: 'Overall request duration'
                      titleKind: 2
                      visualization: {
                        chartType: 2
                        legendVisualization: {
                          isVisible: true
                          position: 2
                          hideSubtitle: false
                        }
                        axisVisualization: {
                          x: {
                            isVisible: true
                            axisType: 2
                          }
                          y: {
                            isVisible: true
                            axisType: 1
                          }
                        }
                      }
                      grouping: {
                        dimension: 'Location'
                      }
                    }
                  }
                  isOptional: true
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
              settings: {}
              filters: {}
            }
          }
          '9': {
            position: {
              x: 0
              y: 4
              rowSpan: 4
              colSpan: 6
            }
            metadata: {
              inputs: [
                {
                  name: 'ComponentId'
                  value: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${applicationInsights.resourceGroup}/providers/microsoft.insights/components/${applicationInsights.name}'
                }
              ]
              type: 'Extension/AppInsightsExtension/PartType/AppMapGalPt'
              settings: {}
            }
          }
          '10': {
            position: {
              x: 6
              y: 4
              rowSpan: 3
              colSpan: 4
            }
            metadata: {
              inputs: [
                {
                  name: 'options'
                  value: {
                    chart: {
                      metrics: [
                        {
                          resourceMetadata: {
                            id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${applicationInsights.resourceGroup}/providers/microsoft.insights/components/${applicationInsights.name}'
                          }
                          name: 'requests/failed'
                          aggregationType: 7
                          namespace: 'microsoft.insights/components'
                          metricVisualization: {
                            displayName: 'Failed requests'
                            resourceDisplayName: applicationInsights.name
                            color: '#EC008C'
                          }
                        }
                      ]
                      title: 'Failed requests'
                      titleKind: 2
                      visualization: {
                        chartType: 3
                      }
                      openBladeOnClick: {
                        openBlade: true
                        destinationBlade: {
                          bladeName: 'ResourceMenuBlade'
                          parameters: {
                            id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${applicationInsights.resourceGroup}/providers/microsoft.insights/components/${applicationInsights.name}'
                            menuid: 'failures'
                          }
                          extensionName: 'HubsExtension'
                          options: {
                            parameters: {
                              id: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${applicationInsights.resourceGroup}/providers/microsoft.insights/components/${applicationInsights.name}'
                              menuid: 'failures'
                            }
                          }
                        }
                      }
                    }
                  }
                  isOptional: true
                }
                {
                  name: 'sharedTimeRange'
                  isOptional: true
                }
              ]
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
              settings: {}
            }
          }
        }
      }
    }
    metadata: {
      model: {}
    }
  }
  tags: {
    'hidden-title': dashboardPlatform.hidden_title
  }
}