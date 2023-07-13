Describe 'Front Door' {
    BeforeAll {
        $rg = "$prefix-$num-$uniqueHash"
        $fd = "$rg-front-door"
        $splat = @{
            rg           = $rg
            templateFile = "$PSScriptRoot\$num.bicep"
            parameters   = @{
                frontDoorName = $fd
                backendAddress    = "google.com"
            }
        }
        Contemplate-AzResources @splat
        $frontDoor = Get-AzFrontDoor -ResourceGroupName $rg -Name $fd
    }

    It 'is in a good state' {
        $frontDoor.ProvisioningState | Should -Be "Succeeded"
        $frontDoor.ResourceState | Should -Be "Enabled"
        $frontDoor.EnabledState | Should -Be "Enabled"
    }

    It 'should balance the load' {
        $frontDoor.LoadBalancingSettings.SampleSize | Should -Be 4
        $frontDoor.LoadBalancingSettings.SuccessfulSamplesRequired | Should -Be 2
    }

    It 'should be healthy' {
        $frontDoor.HealthProbeSettings.Path | Should -Be "/"
        $frontDoor.HealthProbeSettings.Protocol | Should -Be "Http"
        $frontDoor.HealthProbeSettings.IntervalInSeconds | Should -Be 120
        $frontDoor.HealthProbeSettings.HealthProbeMethod | Should -Be "Get"
    }

    It 'should be healthy' {
        $frontDoor.HealthProbeSettings.Path | Should -Be "/"
        $frontDoor.HealthProbeSettings.Protocol | Should -Be "Http"
        $frontDoor.HealthProbeSettings.IntervalInSeconds | Should -Be 120
        $frontDoor.HealthProbeSettings.HealthProbeMethod | Should -Be "Get"
    }

    It 'redirect to a secure connection' {
        $frontDoor.RoutingRules.AcceptedProtocols | Should -Be "Http"
        $frontDoor.RoutingRules.PatternsToMatch | Should -Be "/*"
        $frontDoor.RoutingRules.RouteConfiguration.RedirectType | Should -Be "Moved"
        $frontDoor.RoutingRules.RouteConfiguration.RedirectProtocol | Should -Be "HttpsOnly"
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}