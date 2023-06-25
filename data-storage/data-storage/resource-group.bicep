targetScope = 'subscription'
@description('Specifies the location for resources.')
param location string = 'string'

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
