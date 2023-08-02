Describe 'Deep Breath' {
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
        Import-AzAutomationRunbook
      [-Path] <String>
      [-Description <String>]
      [-Name <String>]
      [-Tags <IDictionary>]
      -Type <String>
      [-LogProgress <Boolean>]
      [-LogVerbose <Boolean>]
      [-Published]
      [-Force]
      [-ResourceGroupName] <String>
      [-AutomationAccountName] <String>
      [-DefaultProfile <IAzureContextContainer>]
      [-WhatIf]
      [-Confirm]
      [<CommonParameters>]
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