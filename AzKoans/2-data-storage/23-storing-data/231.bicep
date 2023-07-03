param storageAccountName string
param location string = resourceGroup().location

// https://azure.github.io/bicep-registry-modules/#storage
module storageAccount 'br/public:storage/storage-account:2.0.3' = {
  name: storageAccountName
  params: {
    location: location
    name: storageAccountName
    isZoneRedundant: true
  }
}
