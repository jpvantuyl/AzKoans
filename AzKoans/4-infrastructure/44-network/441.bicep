@description('The location of all resources')
param location string = resourceGroup().location

@description('The name of the Hub vNet')
param vNetHubName string = 'vnet-hub'

@description('The name of the Spoke vNet')
param vNetSpokeName string = 'vnet-spoke'

@description('The name of the Virtual Machine')
param vmName string = 'vm1'

@description('The size of the Virtual Machine')
param vmSize string = 'Standard_B1s'

@description('The administrator username')
param adminUsername string

@description('The administrator password')
@secure()
param adminPassword string

@description('The name of the Azure Bastion host')
param bastionHostName string = 'bastion1'

var vNetHubPrefix = '10.0.0.0/16'
var subnetBastionPrefix = '10.0.0.0/26'
var vNetSpokePrefix = '10.1.0.0/16'
var subnetSpokeName = 'Subnet-1'
var subnetSpokePrefix = '10.1.0.0/24'

resource vNetHub 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vNetHubName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNetHubPrefix
      ]
    }
    subnets: [
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: subnetBastionPrefix
        }
      }
    ]
  }
}

resource vNetSpoke 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vNetSpokeName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNetSpokePrefix
      ]
    }
    subnets: [
      {
        name: subnetSpokeName
        properties: {
          addressPrefix: subnetSpokePrefix
        }
      }
    ]
  }
}

resource vNetHubSpokePeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  parent: vNetHub
  name: 'peering-to-${vNetSpokeName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vNetSpoke.id
    }
  }
}

resource vNetSpokeHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  parent: vNetSpoke
  name: 'peering-to-${vNetHubName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vNetHub.id
    }
  }
}

resource vNetHubSpokePeering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  parent: vNetHub
  name: 'peering-to-${vNetSpokeName2}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vNetSpoke2.id
    }
  }
}

resource vNetSpokeHubPeering2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  parent: vNetSpoke2
  name: 'peering2-to-${vNetHubName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: vNetHub.id
    }
  }
}

resource vNetSpoke2 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vNetSpokeName2
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNetSpokePrefix2
      ]
    }
    subnets: [
      {
        name: subnetSpokeName2
        properties: {
          addressPrefix: subnetSpokePrefix2
        }
      }
    ]
  }
}

resource bastionPublicIP 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: '${bastionHostName}-pip'
  location: location
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
  }
}

resource bastionHost 'Microsoft.Network/bastionHosts@2022-07-01' = {
  name: bastionHostName
  location: location
  properties: {
    ipConfigurations: [
      {
        properties: {
          subnet: {
            id: '${vNetHub.id}/subnets/AzureBastionSubnet'
          }
          publicIPAddress: {
            id: bastionPublicIP.id
          }
          privateIPAllocationMethod: 'Dynamic'
        }
        name: 'ipconfig1'
      }
    ]
  }
}

resource vmNic 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: '${vmName}-nic-01'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${vNetSpoke.id}/subnets/${subnetSpokeName}'
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        name: '${vmName}-os-01'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vmNic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource vmNic 'Microsoft.Network/networkInterfaces@2022-07-01' = {
  name: '${vmName}-nic-02'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig2'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${vNetSpoke2.id}/subnets/${subnetSpokeName2}'
          }
        }
      }
    ]
  }
}

resource vm2 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: vmName2
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName2
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        name: '${vmName}-os-01'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vmNic2.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource connectionMonitor 'Microsoft.Network/networkWatchers/connectionMonitors@2023-02-01' = {
  name: connectionMonitor
  location: location
  tags: tags
  // parent: resourceSymbolicName
  properties: {
    autoStart: bool
    destination: {
      // address: 
      port: 22
      resourceId: vm2.id
    }
    endpoints: [
      {
        address: 'string'
        coverageLevel: 'Low'
        filter: {
          items: [
            {
              address: 'string'
              type: 'AgentAddress'
            }
          ]
          type: 'Include'
        }
        name: 'string'
        resourceId: 'string'
        scope: {
          exclude: [
            {
              address: 'string'
            }
          ]
          include: [
            {
              address: 'string'
            }
          ]
        }
        type: 'AzureVM'
      }
    ]
    monitoringIntervalInSeconds: 60
    notes: 'string'
    outputs: [
      {
        type: 'Workspace'
        workspaceSettings: {
          workspaceResourceId: 'string'
        }
      }
    ]
    source: {
      port: int
      resourceId: 'string'
    }
    testConfigurations: [
      {
        httpConfiguration: {
          method: 'string'
          path: 'string'
          port: int
          preferHTTPS: bool
          requestHeaders: [
            {
              name: 'string'
              value: 'string'
            }
          ]
          validStatusCodeRanges: [
            'string'
          ]
        }
        icmpConfiguration: {
          disableTraceRoute: bool
        }
        name: 'string'
        preferredIPVersion: 'string'
        protocol: 'string'
        successThreshold: {
          checksFailedPercent: int
          roundTripTimeMs: int
        }
        tcpConfiguration: {
          destinationPortBehavior: 'string'
          disableTraceRoute: bool
          port: int
        }
        testFrequencySec: int
      }
    ]
    testGroups: [
      {
        destinations: [
          'string'
        ]
        disable: bool
        name: 'string'
        sources: [
          'string'
        ]
        testConfigurations: [
          'string'
        ]
      }
    ]
  }
}
