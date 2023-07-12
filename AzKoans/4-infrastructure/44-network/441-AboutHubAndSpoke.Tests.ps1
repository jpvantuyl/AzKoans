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
        $virtualNetwork = Get-AzVirtualNetwork -ResourceGroupName $myResourceGroup -Name $vnet
    }

    It 'is in a good state' {
        $virtualNetwork.Status | Should -Be "Running"
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}