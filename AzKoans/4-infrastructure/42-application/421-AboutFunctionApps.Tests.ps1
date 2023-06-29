param($location, $prefix, $uniqueHash, $tags)
Describe 'Function App' {
    BeforeAll {
        $num = $MyInvocation.MyCommand.ScriptBlock.File.Split([IO.Path]::DirectorySeparatorChar)[-1].Substring(0,3)
        $rg = "$prefix-$num-$uniqueHash"
        $st = "$prefix$($num)st$uniqueHash"
        $fn = "$($prefix)-$num-fn-$uniqueHash"
        $splat = @{
            rg = $rg
            templateFile = "$PSScriptRoot\main.bicep"
            parameters = @{
                location = $location
                storageAccountName = $st
                functionAppName = $fn
                tags = $tags
            }
        }
        Contemplate-AzResources @splat
        $functionApp = Get-AzFunctionApp -ResourceGroupName $rg -Name $fn
    }

    Context 'when we look at it' {
        It 'is in a good state' {
            $functionApp.Status | Should -Be "Running"
        }
        
        It 'renders a page' {
            $response = Invoke-WebRequest -Uri "https://$fn.azurewebsites.net"
            $response.StatusCode | Should -Be 200
            $response.Content | Should -BeLike "*Your Functions 4.0 app is up and running*"
        }
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}