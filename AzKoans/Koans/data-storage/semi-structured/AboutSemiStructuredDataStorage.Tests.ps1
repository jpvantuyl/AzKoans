using module PSKoans
[Koan(Position = 111)]
param()
Describe 'Semi-Structured Data Storage' {
    BeforeAll {
        az deployment sub create --location EastUS --template-file "$PSScriptRoot\main.bicep" --name (get-date).Ticks
    }

    It 'foo' {
        $true | Should -Be $true
    }
}