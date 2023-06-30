Describe 'Budgets' {
    BeforeAll {
        $rg = "$prefix-$num-$uniqueHash"
        $splat = @{
            rg           = $rg
            templateFile = "$PSScriptRoot\$num.bicep"
            parameters   = @{
                startDt = (Get-Date).ToString("yyyy-MM-01")
            }
        }
        Contemplate-AzResources @splat
        $budget = Get-AzConsumptionBudget
    }

    It 'have a limit set' {
        $budget.Amount | Should -Be 100
        $budget.TimeGrain | Should -Be Monthly
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}