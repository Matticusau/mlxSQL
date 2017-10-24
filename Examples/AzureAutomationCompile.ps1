#
# Compile the DSC configuration and upload it to the Automation account
#
$scriptpath = Split-Path -Path $PSCommandPath -Parent

# log into the Azure Account
Login-AzureRmAccount

# variables
$automationrgname = 'ml-rg-automation'
$automationAccount = 'ml-automation'

$ConfigurationNames = @('AzureAutomationConfig');

foreach ($configurationName in $ConfigurationNames)
{
    $DscPath = Join-Path -Path ($scriptpath) -ChildPath "$($configurationName).ps1"

    $ConfigData = @{
        AllNodes = @(
            @{
                NodeName = "*"
                PSDscAllowPlainTextPassword = $True
                PSDscAllowDomainUser = $true
            },
            @{
                NodeName = "node_$($configurationName)"
                SQLInstanceName = 'MSSQLSERVER'
                SourcePath = 'C:\Install'
                AdminAccount = 'sa'
            }
        )}
    $params = @{"Credentials"='Cred-StorAcc-BinaryStorage'}
    Import-AzureRmAutomationDscConfiguration -SourcePath $DscPath -Force -Description "Test configuration fro the mlxSql module" -AutomationAccountName $automationAccount -ResourceGroupName $automationrgname -Published
    $CompilationJob = Start-AzureRmAutomationDscCompilationJob -AutomationAccountName $automationAccount -ResourceGroupName $automationRgName -ConfigurationName $configurationName -ConfigurationData $ConfigData -Parameters $params


    while($CompilationJob.EndTime –eq $null -and $CompilationJob.Exception –eq $null)
    {
        $CompilationJob = $CompilationJob | Get-AzureRmAutomationDscCompilationJob
        Start-Sleep -Seconds 3
    }

    $CompilationJob | Get-AzureRmAutomationDscCompilationJobOutput –Stream Any
}


