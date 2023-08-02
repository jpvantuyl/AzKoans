@description('Specify the name of your Automation Account')
param automationAccountName string

@description('Default modules URI')
param modulesUri string = 'https://devopsgallerystorage.blob.core.windows.net/packages/'

@description('Specify the region for your automation account')
@allowed([
  'westeurope'
  'southeastasia'
  'eastus2'
  'southcentralus'
  'japaneast'
  'northeurope'
  'canadacentral'
  'australiasoutheast'
  'centralindia'
  'westcentralus'
  'usgovvirginia'
  'usgovtexas'
  'usgovarizona'
])
param automationRegion string

@description('URI to artifacts location')
param _artifactsLocation string = deployment().properties.templateLink.uri

@description('The sasToken required to access _artifactsLocation.  When the template is deployed using the accompanying scripts, a sasToken will be automatically generated')
@secure()
param _artifactsLocationSasToken string = ''

var assets = {
  aaVariables: {
    AzureSubscriptionId: {
      name: 'AzureSubscriptionId'
      description: 'Azure subscription Id'
    }
  }
}
var asrScripts = {
  runbooks: [
    {
      name: 'ASR-AddPublicIp'
      url: uri(_artifactsLocation, 'scripts/ASR-AddPublicIp.ps1${_artifactsLocationSasToken}')
      version: '1.0.0.0'
      type: 'PowerShell'
      description: 'ASR Runbook to enable public IP on every VM in a Recovery Plan'
    }
  ]
  // modules: [
  //   {
  //     name: 'AzureRm.Compute'
  //     url: uri(modulesUri, 'azurerm.compute.2.8.0.nupkg')
  //   }
  //   {
  //     name: 'AzureRm.Resources'
  //     url: uri(modulesUri, 'azurerm.resources.3.7.0.nupkg')
  //   }
  //   {
  //     name: 'AzureRm.Network'
  //     url: uri(modulesUri, 'azurerm.network.3.6.0.nupkg')
  //   }
  //   {
  //     name: 'AzureRm.Automation'
  //     url: uri(modulesUri, 'azurerm.automation.1.0.3.nupkg')
  //   }
  // ]
}
// var azureRmProfile = {
//   name: 'AzureRm.Profile'
//   url: uri(modulesUri, 'azurerm.profile.2.7.0.nupkg')
// }

resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' = {
  name: automationAccountName
  location: automationRegion
  properties: {
    sku: {
      name: 'Basic'
    }
  }
}

// resource accountVariable 'Microsoft.Automation/automationAccounts/variables@2022-08-08' = {
//   parent: automationAccount
//   name: assets.aaVariables.AzureSubscriptionId.name
//   properties: {
//     description: assets.aaVariables.AzureSubscriptionId.description
//     value: '"${subscription().subscriptionId}"'
//   }
// }

resource accountRunbook 'Microsoft.Automation/automationAccounts/runbooks@2022-08-08' = {
  name: '${automationAccountName}/${asrScripts.runbooks[i].Name}'
  location: automationRegion
  properties: {
    description: asrScripts.runbooks[i].description
    runbookType: asrScripts.runbooks[i].type
    logProgress: false
    logVerbose: true
    publishContentLink: {
      uri: asrScripts.runbooks[i].url
      version: asrScripts.runbooks[i].version
    }
  }
  dependsOn: [
    automationAccount
  ]
}

// resource profileModule 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = {
//   parent: automationAccount
//   name: azureRmProfile.name
//   location: automationRegion
//   properties: {
//     contentLink: {
//       uri: azureRmProfile.url
//     }
//   }
// }

// resource scriptModule 'Microsoft.Automation/automationAccounts/modules@2022-08-08' = [for i in range(0, length(asrScripts.modules)): {
//   name: '${automationAccountName}/${asrScripts.modules[i].Name}'
//   location: automationRegion
//   properties: {
//     contentLink: {
//       uri: asrScripts.modules[i].url
//     }
//   }
//   dependsOn: [
//     automationAccount
//     profileModule
//   ]
// }]
