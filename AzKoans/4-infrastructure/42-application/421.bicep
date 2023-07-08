param storageAccountName string
param functionAppName string
param tags object
param location string = resourceGroup().location

// https://azure.github.io/bicep-registry-modules/#storage
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_ZRS'
  }
  kind: 'StorageV2'
  properties: {}
}

// https://azure.github.io/bicep-registry-modules/#compute
module funcApp 'br/public:compute/function-app:1.1.2' = {
  name: functionAppName
  dependsOn: [
    storageAccount
  ]
  params: {
    name: functionAppName
    location: location
    sku: {
      name: 'Y1'
      tier: 'Dynamic'
      size: 'Y1'
      family: 'Y'
      capacity: 0
    }
    tags: tags
    storageAccountName: storageAccountName
    storgeAccountResourceGroup: resourceGroup().name
    enableSourceControl: false
    enableDockerContainer: true
    identityType: 'SystemAssigned'
    dockerImage: 'mcr.microsoft.com/azure-functions/dotnet:4-appservice-quickstart'
    serverOS: 'Linux'
    enableVnetIntegration: false
    // connectionStringProperties: {
    //   name: 'connectionstrings'
    //   kind: 'string'
    //   parent: sites
    //   properties: connectionStringProperties
    // }
  }
  scope: resourceGroup()
}
