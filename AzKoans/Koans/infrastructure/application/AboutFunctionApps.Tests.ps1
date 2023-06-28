param($location, $prefix, $uniqueHash, $tags)
Describe 'Function App' {
    BeforeAll {
        $rg = "$prefix-311-$uniqueHash"
        $st = "$($prefix)311st$uniqueHash"
        $fn = "$($prefix)-311-fn-$uniqueHash"
        if ("$((Get-AzResourceGroup -Name $rg).ProvisioningState)" -ne "Succeeded") {New-AzResourceGroup -Location $location -Name $rg -Tag $tags -Verbose}
        New-AzResourceGroupDeployment -TemplateFile "$PSScriptRoot\main.bicep" -Name (get-date).Ticks -ResourceGroupName $rg -Verbose -TemplateParameterObject @{ location = $location; storageAccountName = $st; functionAppName = $fn; tags = $tags }
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