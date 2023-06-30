param($num, $location, $prefix, $uniqueHash, $tags)
Describe 'Function App' {
    BeforeAll {
        $rg = "$prefix-$num-$uniqueHash"
        $st = "$prefix$($num)st$uniqueHash"
        $fn = "$($prefix)-$num-fn-$uniqueHash"
        $splat = @{
            rg           = $rg
            templateFile = "$PSScriptRoot\main.bicep"
            parameters   = @{
                location           = $location
                storageAccountName = $st
                functionAppName    = $fn
                tags               = $tags
            }
        }
        Contemplate-AzResources @splat
        $functionApp = Get-AzFunctionApp -ResourceGroupName $rg -Name $fn
    }

    It 'is in a good state' {
        $functionApp.Status | Should -Be "Running"
    }
        
    It 'renders a page' {
        $response = Invoke-WebRequest -Uri "https://$fn.azurewebsites.net"
        $response.StatusCode | Should -Be 200
        $response.Content | Should -BeLike "*Azure Functions is an event-based serverless compute experience to accelerate your development*"
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}