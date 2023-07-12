Describe 'Cosmos DB' {
    BeforeAll {
        $rg = "$prefix-$num-$uniqueHash"
        $act = "$rg-cosmos"
        $splat = @{
            rg           = $rg
            templateFile = "$PSScriptRoot\$num.bicep"
            parameters   = @{
                accountName = $act
            }
        }
        Contemplate-AzResources @splat
        $cosmosDb = Get-AzCosmosDBAccount -ResourceGroupName $rg -Name $act
    }

    It 'has a type' {
        $cosmosDb.DatabaseAccountOfferType | Should -Be "Standard"
    }

    It 'is available on the internet' {
        $cosmosDb.PublicNetworkAccess | Should -Be "Enabled"
    }

    It 'can write from multiple locations' {
        $cosmosDb.EnableMultipleWriteLocations | Should -Be $false
        $cosmosDb.Locations.Count | Should -Be 1
    }

    It 'has a consistency policy' {
        $cosmosDb.ConsistencyPolicy.DefaultConsistencyLevel | Should -Be "Session"
    }

    It 'has automatic failover' {
        $cosmosDb.EnableAutomaticFailover | Should -Be $false
        $cosmosDb.FailoverPolicies.Count | Should -Be 1
    }

    It 'has analytical storage' {
        $cosmosDb.EnableAnalyticalStorage | Should -Be $true
        $cosmosDb.AnalyticalStorageConfiguration.SchemaType | Should -Be "WellDefined"
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}