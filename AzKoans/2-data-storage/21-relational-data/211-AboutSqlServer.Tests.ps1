Describe 'SQL Server' {
    BeforeAll {
        $rg = "$prefix-$num-$uniqueHash"
        $sql = "$rg-sql"
        $db = "$sql-db"
        $splat = @{
            rg           = $rg
            templateFile = "$PSScriptRoot\$num.bicep"
            parameters   = @{
                serverName                 = $sql
                sqlDBName                  = $db
                administratorLogin         = New-Guid
                administratorLoginPassword = New-Guid
                tags                       = $tags
            }
        }
        Contemplate-AzResources @splat
        $sqlServer = Get-AzSqlServer -ResourceGroupName $rg -Name $sql
        $database = Get-AzSqlDatabase -ResourceGroupName $rg -DatabaseName $db -ServerName $sql
        # if (-not $database.Tags.ContainsKey("Database")) {
        #             Restore-SqlDatabase `
        #     -ReplaceDatabase `
        #     -ServerInstance . `
        #     -Database "SampleDatabase" `
        #     -BackupFile "$pwd\AdventureWorks2016.bak" `
        #     -RelocateFile $relocateFiles `
        #     -Credential $credentials; 
        # }
        # https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.datamigration/azure-database-migration-service/AdventureWorks2016.bak
    }

    It 'has a version' {
        $sqlServer.ServerVersion | Should -Be 12.0
    }

    AfterAll {
        $destroy = $false
        if ($destroy) {
            Get-AzResourceGroup -Name $rg | Remove-AzResourceGroup -Force -Verbose
        }
    }
}