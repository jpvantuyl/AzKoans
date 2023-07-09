Describe 'Application Insights' {
    BeforeAll {
        $rg = "$prefix-$num-$uniqueHash"
        $ap = "$rg-app"
        $appInsightName = "$ap-appi"
        $splat = @{
            rg           = $rg
            templateFile = "$PSScriptRoot\$num.bicep"
            parameters   = @{
                appName        = $ap
                appInsightName = $appInsightName
                email          = $email
            }
        }
        Contemplate-AzResources @splat
        $applicationInsights = Get-AzApplicationInsights -Name $appInsightName -ResourceGroupName $rg -Full
    }

    It 'should be limited' {
        $applicationInsights.IsCapped | Should -Be $false
        $applicationInsights.Cap | Should -Be 100
        $applicationInsights.StopSendNotificationWhenHitCap | Should -Be $false
        $applicationInsights.SamplingPercentage | Should -Be 0.25
    }

    It 'should be focused' {
        $applicationInsights.Kind | Should -Be "web"
        $applicationInsights.ApplicationType | Should -Be "web"
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}