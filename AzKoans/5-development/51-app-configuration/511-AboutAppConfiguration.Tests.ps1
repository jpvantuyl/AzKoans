Describe 'App Configuration' {
    BeforeAll {
        $rg = "$prefix-$num-$uniqueHash"
        $conf = "$rg-conf"
        $splat = @{
            rg           = $rg
            templateFile = "$PSScriptRoot\$num.bicep"
            parameters   = @{
                configStoreName = $conf
                tags            = $tags
            }
        }
        Contemplate-AzResources @splat
        $appConfigurationStore = Get-AzAppConfigurationStore -Name $conf -ResourceGroupName $rg
    }

    It 'is in a good state' {
        $appConfigurationStore.ProvisioningState | Should -Be "Succeeded"
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}