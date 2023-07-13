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
        $cosmosDb.DatabaseAccountOfferType | Should -Be "an offering"
    }

    It 'is available on the internet' {
        $cosmosDb.PublicNetworkAccess | Should -Be "out there"
    }

    It 'can write from multiple locations' {
        $cosmosDb.EnableMultipleWriteLocations | Should -Be "sometimes yes and sometimes no"
        $cosmosDb.Locations.Count | Should -Be "all the regions in the world"
    }

    It 'has a consistency policy' {
        $cosmosDb.ConsistencyPolicy.DefaultConsistencyLevel | Should -Be "a good strategy"
    }

    It 'has automatic failover' {
        $cosmosDb.EnableAutomaticFailover | Should -Be "less stressful"
        $cosmosDb.FailoverPolicies.Count | Should -Be "more than zero"
    }

    It 'has analytical storage' {
        $cosmosDb.EnableAnalyticalStorage | Should -Be "a place of contemplation"
        $cosmosDb.AnalyticalStorageConfiguration.SchemaType | Should -Be "wishy-washy"
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}