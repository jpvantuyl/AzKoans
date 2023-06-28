param($location, $prefix, $uniqueHash)
Describe 'Semi-Structured Data Storage' {
    BeforeAll {
        $rg = "$prefix-111-$uniqueHash"
        New-AzResourceGroup -Location $location -Name $rg -Verbose
        New-AzResourceGroupDeployment -TemplateFile "$PSScriptRoot\main.bicep" -Name (get-date).Ticks -ResourceGroupName $rg -Verbose
    }

    It 'foo' {
        $true | Should -Be $true
    }

    AfterAll {
        $destroy = $true
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force
        }
    }
}