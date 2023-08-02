@description('Specifies the name of the App Configuration store.')
param configStoreName string

@description('Specifies the Azure location where the app configuration store should be created.')
param location string = resourceGroup().location

@description('Specifies the content type of the key-value resources. For feature flag, the value should be application/vnd.microsoft.appconfig.ff+json;charset=utf-8. For Key Value reference, the value should be application/vnd.microsoft.appconfig.keyvaultref+json;charset=utf-8. Otherwise, it\'s optional.')
param contentType string = 'the-content-type'

resource configStore 'Microsoft.AppConfiguration/configurationStores@2023-03-01' = {
  name: configStoreName
  location: location
  sku: {
    name: 'standard'
  }
  properties: {
    createMode: 'Default'
    disableLocalAuth: false
    enablePurgeProtection: false
    // encryption: {
    //   keyVaultProperties: {
    //     identityClientId: 'string'
    //     keyIdentifier: 'string'
    //   }
    // }
    publicNetworkAccess: 'Enabled'
    softDeleteRetentionInDays: 1
  }
  tags: tags
}

resource configStoreKeyValue1 'Microsoft.AppConfiguration/configurationStores/keyValues@2023-03-01' {
  parent: configStore
  name: '${configStore}-feature-flag'
  properties: {
    value: true
    contentType: ' application/vnd.microsoft.appconfig.ff+json;charset=utf-8'
    tags: tags
  }
}

resource configStoreKeyValue2 'Microsoft.AppConfiguration/configurationStores/keyValues@2023-03-01' {
  parent: configStore
  name: '${configStore}-key-value'
  properties: {
    value: 'shhhhhhhhhhhh..........'
    contentType: 'normal-ish'
    tags: tags
  }
}
