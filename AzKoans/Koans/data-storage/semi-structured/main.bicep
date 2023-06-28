param location string
param storageAccountName string

// https://azure.github.io/bicep-registry-modules/#storage
module storageAccount 'br/public:storage/storage-account:2.0.3' = {
  name: storageAccountName
  params: {
    location: location
    name: storageAccountName
    isZoneRedundant: true
  }
}

output storageAccountID string = storageAccount.outputs.id
