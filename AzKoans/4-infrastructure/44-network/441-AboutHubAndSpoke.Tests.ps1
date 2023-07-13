Describe 'Hub and Spoke' {
    BeforeAll {
        $rg = "$prefix-$num-$uniqueHash"
        $vnet = "$rg-vnet"
        $splat = @{
            rg           = $rg
            templateFile = "$PSScriptRoot\$num.bicep"
            parameters   = @{
                adminUsername = New-Guid
                adminPassword = New-Guid
                vNetHubName   = $vnet
            }
        }
        Contemplate-AzResources @splat
        $virtualNetwork = Get-AzVirtualNetwork -ResourceGroupName $rg -Name $vnet
    }

    It 'is in a good state' {
        $virtualNetwork.ProvisioningState | Should -Be "Succeeded"
    }

    It 'has an allocated address space' {
        $virtualNetwork.AddressSpace.AddressPrefixes | Should -Be "10.0.0.0/16"
    }

    It 'is protected from distributed denial of service' {
        $virtualNetwork.EnableDdosProtection | Should -Be $false
    }

    It 'should be peered' {
        $virtualNetwork.VirtualNetworkPeerings.PeeringState | Should -Be "Connected"
        $virtualNetwork.VirtualNetworkPeerings.AllowVirtualNetworkAccess | Should -Be $true
        $virtualNetwork.VirtualNetworkPeerings.AllowForwardedTraffic | Should -Be $false
        $virtualNetwork.VirtualNetworkPeerings.AllowGatewayTransit | Should -Be $false
        $virtualNetwork.VirtualNetworkPeerings.UseRemoteGateways | Should -Be $false
        $virtualNetwork.VirtualNetworkPeerings.PeeredRemoteAddressSpace.AddressPrefixes | Should -Be "10.1.0.0/16"
    }

    It 'should have a subnet' {
        $virtualNetwork.Subnets.AddressPrefix | Should -Be "10.0.0.0/26"
        $virtualNetwork.Subnets.PrivateLinkServiceNetworkPolicies | Should -Be $true
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}