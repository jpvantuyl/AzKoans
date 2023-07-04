Describe 'Budgets' {
    BeforeAll {
        $rg = "$prefix-$num-$uniqueHash"
        $bn = "$prefix-$num-$uniqueHash-budget"
        $splat = @{
            rg           = $rg
            templateFile = "$PSScriptRoot\$num.bicep"
            parameters   = @{
                budgetName = $bn
                startDt    = (Get-Date).ToString("yyyy-MM-01")
            }
        }
        Contemplate-AzResources @splat
        $response = Invoke-WebRequest -UseBasicParsing "https://management.azure.com/subscriptions/$($config.subscriptionId)/resourceGroups/$rg/providers/Microsoft.Consumption/budgets?api-version=2021-10-01" -Method GET -Headers @{"Authorization" = "Bearer $((Get-AzAccessToken).Token)" }
        $budget = (($response.content | ConvertFrom-Json).value | ? {$_.name -eq 'jpvant-112-b451-budget'}).properties
    }

    It 'have a limit set' -Skip {
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