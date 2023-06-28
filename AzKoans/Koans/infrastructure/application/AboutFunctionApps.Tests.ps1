param($location, $prefix, $uniqueHash, $tags)
Describe 'Function App' {
    BeforeAll {
        $rg = "$prefix-311-$uniqueHash"
        $st = "$($prefix)311st$uniqueHash"
        $fn = "$($prefix)-311-fn-$uniqueHash"
        if ("$((Get-AzResourceGroup -Name $rg).ProvisioningState)" -ne "Succeeded") {New-AzResourceGroup -Location $location -Name $rg -Tag $tags -Verbose}
        New-AzResourceGroupDeployment -TemplateFile "$PSScriptRoot\main.bicep" -Name (get-date).Ticks -ResourceGroupName $rg -Verbose -TemplateParameterObject @{ location = $location; storageAccountName = $st; functionAppName = $fn; tags = $tags }
        $functionApp = Get-AzFunctionApp -ResourceGroupName $rg -Name $fn
    }

    Context 'when we look at it' {
        It 'is using the latest storage version' {
            # https://learn.microsoft.com/en-us/azure/storage/common/storage-account-upgrade?tabs=azure-portal
            # the previous version didn't have hot and cool access

            $storageAccount.Kind | Should -Be "StorageV2"
        }
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}