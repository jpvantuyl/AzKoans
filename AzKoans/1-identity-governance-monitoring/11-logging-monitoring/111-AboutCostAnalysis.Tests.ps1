Describe 'Cost Analysis' {
    BeforeAll {
        $rg = "$prefix-$num-$uniqueHash"
        $splat = @{
            rg           = $rg
            templateFile = "$PSScriptRoot\$num.bicep"
            parameters   = @{
                email = $email
            }
        }
        Contemplate-AzResources @splat
        $costManagementReport = Invoke-AzCostManagementQuery -Scope (Get-AzResourceGroup -Name $rg).ResourceId -Timeframe MonthToDate -Type Usage -DatasetGranularity 'Daily'
    }

    It 'sends daily cost alerts' -Skip {
        $____ = "meditate"
        $costManagementReport.Row[0][0] | Should -BeLike "*$____*"
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}