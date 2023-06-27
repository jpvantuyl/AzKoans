// https://azure.github.io/bicep-registry-modules/#storage
targetScope = 'subscription'

@description('Specifies the location for resources.')
param location string = 'eastus'
param uniqueHash string = uniqueString(az.subscription().subscriptionId)
param resourceGroupName string = 'azkoans-data-storage-${uniqueHash}'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  managedBy: 'azkoans'
  properties: {}
}





// param name string = 
// param newOrExisting string = 'new'
// param resourceGroupName string = 'myresourcegroup'
param isZoneRedundant bool = true

module storageAccount 'br/public:storage/storage-account:2.0.3' = {
  name: 'azkoansstorage${uniqueHash}'
  params: {
    location: location
    name: 'azkoansst${uniqueHash}'
    isZoneRedundant: isZoneRedundant
  }
  scope: resourceGroup
}

output storageAccountID string = storageAccount.outputs.id



