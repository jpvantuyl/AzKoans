// https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/components?pivots=deployment-language-bicep
param skuName string = 'S1'
param skuCapacity int = 1
param location string
param appName string

var appServicePlanName = toLower('${appName}-asp')
var webSiteName = toLower('${appName}-wapp')
var appInsightName = toLower('${appName}-appi')
var logAnalyticsName = toLower('${appName}-la')

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  tags: {
    displayName: 'HostingPlan'
    ProjectName: appName
  }
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: webSiteName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  tags: {
    displayName: 'Website'
    ProjectName: appName
  }
  dependsOn: [
    logAnalyticsWorkspace
  ]
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
    }
  }
}

resource appServiceLogging 'Microsoft.Web/sites/config@2020-06-01' = {
  parent: appService
  name: 'appsettings'
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsights.properties.InstrumentationKey
  }
  dependsOn: [
    appServiceSiteExtension
  ]
}

resource appServiceSiteExtension 'Microsoft.Web/sites/siteextensions@2020-06-01' = {
  parent: appService
  name: 'Microsoft.ApplicationInsights.AzureWebSites'
  dependsOn: [
    appInsights
  ]
}

resource appServiceAppSettings 'Microsoft.Web/sites/config@2020-06-01' = {
  parent: appService
  name: 'logs'
  properties: {
    applicationLogs: {
      fileSystem: {
        level: 'Warning'
      }
    }
    httpLogs: {
      fileSystem: {
        retentionInMb: 40
        enabled: true
      }
    }
    failedRequestsTracing: {
      enabled: true
    }
    detailedErrorMessages: {
      enabled: true
    }
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightName
  location: location
  kind: 'web'
  tags: {
    displayName: 'AppInsight'
    ProjectName: appName
  }
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: logAnalyticsName
  location: location
  tags: {
    displayName: 'Log Analytics'
    ProjectName: appName
  }
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 120
    features: {
      searchVersion: 1
      legacy: 0
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

param responseTimeThreshold int = 3
param workspaceName string = 'myWorkspace'

@description('Name of the application insights resource.')
param applicationInsightsName string = 'myApplicationInsights'

var responseAlertName = 'ResponseTime-${toLower(applicationInsightsName)}'

resource metricAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: responseAlertName
  location: 'global'
  properties: {
    description: 'Response time alert'
    severity: 0
    enabled: true
    scopes: [
      applicationInsights.id
    ]
    evaluationFrequency: 'PT1M'
    windowSize: 'PT5M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: '1st criterion'
          metricName: 'requests/duration'
          operator: 'GreaterThan'
          threshold: responseTimeThreshold
          timeAggregation: 'Average'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
    }
    actions: [
      {
        actionGroupId: emailActionGroup.id
      }
    ]
  }
}

resource emailActionGroup 'microsoft.insights/actionGroups@2019-06-01' = {
  name: 'emailActionGroup'
  location: 'global'
  properties: {
    groupShortName: 'string'
    enabled: true
    emailReceivers: [
      {
        name: 'Example'
        emailAddress: 'example@test.com'
        useCommonAlertSchema: true
      }
    ]
  }
}
