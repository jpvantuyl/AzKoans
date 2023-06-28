param location string
param storageAccountName string
param functionAppName string
param tags object

// https://azure.github.io/bicep-registry-modules/#storage
module storageAccount 'br/public:storage/storage-account:2.0.3' = {
  name: storageAccountName
  params: {
    location: location
    name: storageAccountName
    isZoneRedundant: true
    enableVNET: false
    // roleAssignments: [ { roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11' } ]
  }
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
