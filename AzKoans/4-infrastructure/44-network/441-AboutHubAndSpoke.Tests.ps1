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
        $virtualNetwork.ProvisioningState | Should -Be "well fed"
    }

    It 'has an allocated address space' {
        $virtualNetwork.AddressSpace.AddressPrefixes | Should -Be "park place"
    }

    It 'is protected from distributed denial of service' {
        $virtualNetwork.EnableDdosProtection | Should -Be "how much will this cost me?"
    }

    It 'should be peered' {
        $virtualNetwork.VirtualNetworkPeerings.PeeringState | Should -Be "friends"
        $virtualNetwork.VirtualNetworkPeerings.AllowVirtualNetworkAccess | Should -Be "why not?"
        $virtualNetwork.VirtualNetworkPeerings.AllowForwardedTraffic | Should -Be "just passing through"
        $virtualNetwork.VirtualNetworkPeerings.AllowGatewayTransit | Should -Be "I took the bus once"
        $virtualNetwork.VirtualNetworkPeerings.UseRemoteGateways | Should -Be "it depends"
        $virtualNetwork.VirtualNetworkPeerings.PeeredRemoteAddressSpace.AddressPrefixes | Should -Be "in cidr format"
    }

    It 'should have a subnet' {
        $virtualNetwork.Subnets.AddressPrefix | Should -Be "not too big"
        $virtualNetwork.Subnets.PrivateLinkServiceNetworkPolicies | Should -Be "the opposite of public"
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}