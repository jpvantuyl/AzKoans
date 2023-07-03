Describe 'Azure Advisor' {
    BeforeAll {
        $rg = "$prefix-$num-$uniqueHash"
        $adv = "$rg-adv"
        $splat = @{
            rg           = $rg
            templateFile = "$PSScriptRoot\$num.bicep"
            parameters   = @{
                email     = $email
                alertName = $adv
            }
        }
        Contemplate-AzResources @splat
        $recommendation = Get-AzAdvisorRecommendation -ResourceGroupName $rg
    }

    It 'should be capped' -Skip {
        $recommendation.IsCapped | Should -Be $false
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}