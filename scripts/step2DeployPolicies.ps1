<#
	.SYNOPSIS
        1. Deploy the managementgroup structure based on templates taen from eslz
        Copy files from an reference implementation https://github.com/Azure/Enterprise-Scale/tree/main/docs/reference this sample is based on Advantureworks.
        Most reference implementation use same files.



	.DESCRIPTION

    Connect-AzAccount
    As this is and managementgroup deployment you should have deployment rights on managementgroup level specified. 
  
   

	.EXAMPLE
	   .\step2DeployPolicies.ps1 -topLevelManagementGroupPrefix "test6" -Location  "WestEurope"
	   
	.LINK

	.Notes
		NAME:      step2DeployPolicies.ps1
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

$deployFile = "policies"
$templateFile = "$($root)/../armTemplates/auxiliary/$($deployFile).json"


Write-Host "Start deploy policies"


New-AzManagementGroupDeployment -TemplateFile $templateFile -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix -ManagementGroupId "$($topLevelManagementGroupPrefix)" -Verbose -Location $Location 



