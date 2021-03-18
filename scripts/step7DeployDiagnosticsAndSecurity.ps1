<#
	.SYNOPSIS
        1. Deploy Policies on Top Level for monitoring an security policies Management Group
        Copy files from an reference implementation https://github.com/Azure/Enterprise-Scale/tree/main/docs/reference this sample is based on Advantureworks.
        Most reference implementation use same files.



	.DESCRIPTION

    Connect-AzAccount
    As this is and Management Group deployment you should have deployment rights on managementgroup level specified. 
    Only the mangement group is provided change the parameters to also enable activity logging for identity and existing landing zone or create remidiation tasks
   

	.EXAMPLE
	   .\step7DeploydiagnosticsAndSecurity.ps1 -topLevelManagementGroupPrefix "test6" -Location  "WestEurope"  -managementSubscriptionId "xxxxxxxx-xxxxxx-xxxxxx"
	   
	.LINK

	.Notes
		NAME:      step7DeploydiagnosticsAndSecurity.ps1
		AUTHOR(s): Mathieu Rietman <marietma@microsoft.com>
		LASTEDIT:  03/18/2021
		KEYWORDS:  eslz diagnosticsAndSecurity managemengroup
#>


param(
    [Parameter(Mandatory = $false)]
    [string]
    $topLevelManagementGroupPrefix = "test5",
    [Parameter(Mandatory = $false)]
    [string]
    $Location = "WestEurope",
    [Parameter(Mandatory = $true)]
    [string]
    $managementSubscriptionId 


    
)
$root = $PSScriptRoot

$deployFile = "diagnosticsAndSecurity"
$templateFile = "$($root)/../armTemplates/auxiliary/$($deployFile).json"
$parameterFile = "$($root)/parameters/$($deployFile).parameters.json"


Write-Host "Start assign policies to top Management group"
If (Test-Path -Path $parameterFile ) {

    New-AzManagementGroupDeployment -ManagementGroupId "$($topLevelManagementGroupPrefix)" -TemplateFile $templateFile -TemplateParameterFile $parameterFile  -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix -managementSubscriptionId $managementSubscriptionId  -Verbose -Location $Location


}
else {

    New-AzManagementGroupDeployment -ManagementGroupId "$($topLevelManagementGroupPrefix)" -TemplateFile $templateFile -TemplateParameterFile $parameterFile  -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix -managementSubscriptionId $managementSubscriptionId  -Verbose -Location $Location



}
