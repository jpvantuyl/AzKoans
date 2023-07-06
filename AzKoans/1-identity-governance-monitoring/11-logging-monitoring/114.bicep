// https://learn.microsoft.com/en-us/azure/advisor/advisor-alerts-bicep?tabs=CLI
param email string
param alertName string
param location string = resourceGroup().location
param keyExpiration int = dateTimeToEpoch(dateTimeAdd(utcNow(), 'P3Y'))

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

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: '${alertName}-kv'
  location: location
  properties: {
    accessPolicies: [
      // {
      //   objectId: 'b24988ac-6180-42a0-ab88-20f7382dd24c' //https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#contributor
      //   tenantId: subscription().tenantId
      //   permissions: {
      //     keys: [
      //       'all'
      //     ]
      //     secrets: [
      //       'all'
      //     ]
      //   }
      // }
    ]
    enableRbacAuthorization: true
    enableSoftDelete: false
    sku: {
      family: 'A'
      name: 'standard'
    }
    softDeleteRetentionInDays: 10
    tenantId: subscription().tenantId
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

// https://learn.microsoft.com/en-us/azure/key-vault/secrets/quick-create-bicep?tabs=CLI
resource secret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
  parent: kv
  name: 'this-secret-has-no-expiration'
  properties: {
    value: 'this is the secret value'
  }
}

resource key 'Microsoft.KeyVault/vaults/keys@2022-07-01' = {
  parent: kv
  name: 'this-key-has-no-expiration'
  properties: {
    kty: 'EC'
    attributes: {
      exp: keyExpiration
    }
  }
}
