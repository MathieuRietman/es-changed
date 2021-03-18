<#
	.SYNOPSIS
        1. Deploy the managementgroup structure based on templates taen from eslz
        Copy files from an reference implementation https://github.com/Azure/Enterprise-Scale/tree/main/docs/reference this sample is based on Advantureworks.
        Most reference implementation use same files.



	.DESCRIPTION

    Connect-AzAccount
    As this is and tenant deployment make sure you have root inherent 
    New-AzRoleAssignment -ObjectId <userobeject ID that run the script> -RoleDefinitionName Owner -Scope /    
   

	.EXAMPLE
	   .\step1DeployMgmtGroups.ps1 -topLevelManagementGroupPrefix "test6" -Location  "WestEurope"
	   
	.LINK

	.Notes
		NAME:      step1DeployMgmtGroups.ps1
		AUTHOR(s): Mathieu Rietman <marietma@microsoft.com>
		LASTEDIT:  03/18/2021
		KEYWORDS:  eslz managemengroup
#>


param(
    [Parameter(Mandatory = $false)]
    [string]
    $topLevelManagementGroupPrefix = "test5",
    [Parameter(Mandatory = $false)]
    [string]
    $Location = "WestEurope"
)

$root = $PSScriptRoot

$deployFile = "mgmtGroups"
$templateFile = "$($root)/../armTemplates/auxiliary/$($deployFile).json"
$parameterFile = "$($root)/parameters/$($deployFile).parameters.json"

#create Management groupmanagement group
Write-Host "Start create management group"
If (Test-Path -Path $parameterFile ) {

    New-AzTenantDeployment -TemplateFile $templateFile -TemplateParameterFile $parameterFile  -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix  -Verbose -Location $Location

}
else {

    New-AzTenantDeployment -TemplateFile $templateFile  -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix  -Verbose -Location $Location

}
