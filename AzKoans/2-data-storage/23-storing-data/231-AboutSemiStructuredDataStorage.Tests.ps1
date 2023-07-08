Describe 'Storage Account' {
    BeforeAll {
        $rg = "$prefix-$num-$uniqueHash"
        $st = "$prefix$($num)st$uniqueHash"
        $splat = @{
            rg           = $rg
            templateFile = "$PSScriptRoot\$num.bicep"
            parameters   = @{
                storageAccountName = $st
            }
        }
        Contemplate-AzResources @splat
        $storageAccount = Get-AzStorageAccount -ResourceGroupName $rg -Name $st
    }

    It 'is using the latest storage version' {
        # https://learn.microsoft.com/en-us/azure/storage/common/storage-account-upgrade?tabs=azure-portal
        # the previous version didn't have hot and cool access

        $storageAccount.Kind | Should -Be "it's highest self"
    }

    It 'is zone redundant' {
        $storageAccount.Sku.Name | Should -Be "everywhere and nowhere"
            
        # zone redundant storage copies data across 3 availability zones in the region
        # https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy#redundancy-in-the-primary-region
    }

    It 'does not have public access from the internet' {
        $storageAccount.PublicNetworkAccess | Should -Be "closed but contain multitudes"
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}