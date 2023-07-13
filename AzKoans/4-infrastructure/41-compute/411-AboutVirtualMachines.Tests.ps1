Describe 'Virtual Machine' {
    BeforeAll {
        $rg = "$prefix-$num-$uniqueHash"
        $vm = "$rg-vm"
        $splat = @{
            rg           = $rg
            templateFile = "$PSScriptRoot\$num.bicep"
            parameters   = @{
                vmName             = $vm
                adminUsername      = New-Guid
                adminPasswordOrKey = New-Guid
                tags               = $tags
            }
        }
        Contemplate-AzResources @splat
        $virtualMachine = Get-AzVM -ResourceGroupName $rg -Name $vm
    }

    It 'is in a good state' {
        $virtualMachine.ProvisioningState | Should -Be "happy"
    }

    It 'is cheap' {
        $virtualMachine.HardwareProfile.VmSize | Should -Be "a word, a symbol, an uppercase letter, a lowercase letter, and a number"
    }

    It 'has an OS' {
        $virtualMachine.OSProfile.WindowsConfiguration -eq $null | Should -Be "empty"
        $virtualMachine.OSProfile.LinuxConfiguration -eq $null | Should -Be "full"
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}