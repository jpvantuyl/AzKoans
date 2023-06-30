// https://learn.microsoft.com/en-us/azure/advisor/advisor-alerts-bicep?tabs=CLI
param email string
param alertName string

resource emailActionGroup 'microsoft.insights/actionGroups@2021-09-01' = {
  name: '${alertName}EmailActionGroup'
  location: 'global'
  properties: {
    groupShortName: 'AzKoans'
    enabled: true
    emailReceivers: [
      {
        name: 'AzKoans'
        emailAddress: email
        useCommonAlertSchema: true
      }
    ]
  }
}

resource alert 'Microsoft.Insights/activityLogAlerts@2020-10-01' = {
  name: alertName
  location: 'global'
  properties: {
    enabled: true
    scopes: [
      resourceGroup().id
    ]
    condition: {
      allOf: [
        {
          field: 'category'
          equals: 'ResourceHealth'
        }
        {
          field: 'status'
          equals: 'Active'
        }
      ]
    }
    actions: {
      actionGroups: [
        {
          actionGroupId: emailActionGroup.id
        }
      ]
    }
  }
}

resource symbolicname 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: '${alertName}-kv'
  location: resourceGroup().location
  properties: {
    accessPolicies: []
    enableRbacAuthorization: false
    enableSoftDelete: false
    sku: {
      family: 'A'
      name: 'standard'
    }
    softDeleteRetentionInDays: 10
    tenantId: subscription().tenantId
  }
}
