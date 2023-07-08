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
                # storageAccountName = $st
                # functionAppName    = $fn
                # tags               = $tags
            }
        }
        Contemplate-AzResources @splat
        $virtualMachine = Get-AzVM -ResourceGroupName $rg -Name $vm
    }

    It 'is in a good state' {
        $virtualMachine.ProvisioningState | Should -Be "Succeeded"
    }

    It 'is cheap' {
        $virtualMachine.HardwareProfile.VmSize | Should -Be "Standard_B1s"
    }

    It 'has an OS' {
        $virtualMachine.OSProfile.WindowsConfiguration -eq $null | Should -Be $true
        $virtualMachine.OSProfile.LinuxConfiguration -eq $null | Should -Be $false
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}