$config = Get-Content "$PSScriptRoot\config.json" | ConvertFrom-Json -AsHashtable

Write-Warning "Take a deep breath`n`nLet it out`n`nDelete AzKoans resource groups`n`nAuthenticating...`n"
pause
Connect-AzAccount -Subscription $config.subscriptionId

Get-AzResourceGroup -Tag @{'Thinking'='Done'} | Remove-AzResourceGroup -Force -Verbose
