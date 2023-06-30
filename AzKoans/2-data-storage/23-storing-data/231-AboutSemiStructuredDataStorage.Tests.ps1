param($num, $location, $prefix, $uniqueHash, $tags)
Describe 'Storage Account' {
    BeforeAll {
        $rg = "$prefix-$num-$uniqueHash"
        $st = "$prefix$($num)st$uniqueHash"
        $splat = @{
            rg           = $rg
            templateFile = "$PSScriptRoot\main.bicep"
            parameters   = @{
                location           = $location
                storageAccountName = $st
            }
        }
        Contemplate-AzResources @splat
        $storageAccount = Get-AzStorageAccount -ResourceGroupName $rg -Name $st
    }

    It 'is using the latest storage version' {
        # https://learn.microsoft.com/en-us/azure/storage/common/storage-account-upgrade?tabs=azure-portal
        # the previous version didn't have hot and cool access

        $storageAccount.Kind | Should -Be "StorageV2"
    }

    It 'is zone redundant' {
        $storageAccount.Sku.Name | Should -Be "Standard_ZRS"
            
        # zone redundant storage copies data across 3 availability zones in the region
        # https://learn.microsoft.com/en-us/azure/storage/common/storage-redundancy#redundancy-in-the-primary-region
    }

    It 'does not have public access from the internet' {
        $storageAccount.PublicNetworkAccess | Should -Be "Disabled"
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}