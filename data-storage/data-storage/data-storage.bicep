@description('Specifies the location for resources.')
param location string = 'string'

param rgLocation string = az.resourceGroup().location
param storageNames array = [
  'storage1'
  'storage2'
]

param containerName string = 'container1'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'string'
  location: location
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  managedBy: 'string'
  properties: {}
}

// Create storages
resource storageAccounts 'Microsoft.Storage/storageAccounts@2021-06-01' = [for name in storageNames: {
  name: '${name}str${uniqueString(resourceGroup().id)}'
  location: rgLocation
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}]

// Create container
resource containers 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = [for (name, i) in storageNames: {
  name: '${storageAccounts[i].name}/default/${containerName}'
  properties: {
    publicAccess: 'None'
    metadata: {}
  }
}]
