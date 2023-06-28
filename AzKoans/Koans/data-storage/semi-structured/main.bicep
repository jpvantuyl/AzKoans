// https://azure.github.io/bicep-registry-modules/#storage
@description('Specifies the location for resources.')
param location string
param resourceGroupName string
param prefix string
param uniqueHash string


// param name string = 
// param newOrExisting string = 'new'
// param resourceGroupName string = 'myresourcegroup'
param isZoneRedundant bool = true

module storageAccount 'br/public:storage/storage-account:2.0.3' = {
  name: '${prefix}st${uniqueHash}'
  params: {
    location: location
    name: '${prefix}st${uniqueHash}'
    isZoneRedundant: isZoneRedundant
  }
}

output storageAccountID string = storageAccount.outputs.id



