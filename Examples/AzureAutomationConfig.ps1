#
# Base configuration for SQL Server
#

Configuration AzureAutomationConfig {
    param(
		[Parameter(Mandatory)]
		[PSCredential]$Credentials
    )

	Import-DscResource -ModuleName mlxSql

    Node $AllNodes.NodeName {

		# Demo SQL Server build

        $SQLInstanceName = $Node.SQLInstanceName
        $Features = "SQLENGINE,FULLTEXT,RS,AS,IS"

		xSqlSetup ($Node.NodeName + $SQLInstanceName)
		{
			#DependsOn = "[WindowsFeature]NET-Framework-Core"
            SourcePath = $Node.SourcePath
            SourceCredential = $Credentials
            InstanceName = $SQLInstanceName
            Features = $Features
            SQLSysAdminAccounts = $Node.AdminAccount
            InstallSharedDir = "C:\Program Files\Microsoft SQL Server"
            InstallSharedWOWDir = "C:\Program Files (x86)\Microsoft SQL Server"
            InstanceDir = "C:\Program Files\Microsoft SQL Server"
            InstallSQLDataDir = "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Data"
            SQLUserDBDir = "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Data"
            SQLUserDBLogDir = "C:\Program Files\Microsoft SQL Server\MSSQL14MSSQLSERVER\MSSQL\Data"
            SQLTempDBDir = "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Data"
            SQLTempDBLogDir = "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Data"
            SQLBackupDir = "C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\Data"
		}

		xSqlFirewall ($Node.NodeName + $SQLInstanceName)
        {
            DependsOn = ("[xSqlSetup]" + $Node.NodeName + $SQLInstanceName)
            SourcePath = $Node.SourcePath
            InstanceName = $SQLInstanceName
            Features = $Features
        }

	} # end of all nodes

} #End of Configuration
