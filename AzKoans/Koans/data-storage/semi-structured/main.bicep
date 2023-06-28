// https://azure.github.io/bicep-registry-modules/#storage
@description('Specifies the location for resources.')
param location string = 'eastus'
param uniqueHash string = uniqueString(az.subscription().subscriptionId)


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
}

output storageAccountID string = storageAccount.outputs.id



