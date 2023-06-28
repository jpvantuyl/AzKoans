using module PSKoans
[Koan(Position = 111)]
param()
Describe 'Semi-Structured Data Storage' {
    BeforeAll {
        New-AzSubscriptionDeployment -Location EastUS -TemplateFile "$PSScriptRoot\main.bicep" -Name (get-date).Ticks
    }

    It 'foo' {
        $true | Should -Be $true
    }

    AfterAll {
        $destroy = $true
        if ($destroy) {
            # Get-AzResourceGroup -Name "ContosoRG01" | Remove-AzResourceGroup -Force
        }
    }
}