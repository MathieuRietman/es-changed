<#
	.SYNOPSIS
        1. Deploy Policies on Identity Management Group
        Copy files from an reference implementation https://github.com/Azure/Enterprise-Scale/tree/main/docs/reference this sample is based on Advantureworks.
        Most reference implementation use same files.



	.DESCRIPTION

    Connect-AzAccount
    As this is and Management Group deployment you should have deployment rights on managementgroup level specified. 
   

	.EXAMPLE
	   .\step5DeployIdentity.ps1 -topLevelManagementGroupPrefix "test6" -Location  "WestEurope" 
	   
	.LINK

	.Notes
		NAME:      step5DeployIdentity.ps1
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
    $Location = "WestEurope",
    [Parameter(Mandatory = $false)]
    [string]
    $identitySubscriptionId 

    
)

$root = $PSScriptRoot

$deployFile = "identity"
$templateFile = "$($root)/../armTemplates/auxiliary/$($deployFile).json"
$parameterFile = "$($root)/parameters/$($deployFile).parameters.json"

if ($identitySubscriptionId -ne ""){

    
    New-AzManagementGroupSubscription -GroupId "$($topLevelManagementGroupPrefix)-identity" -SubscriptionId $managementSubscriptionId         
}

Write-Host "Start assign policies to identity management group"
If (Test-Path -Path $parameterFile ) {

    New-AzManagementGroupDeployment -ManagementGroupId "$($topLevelManagementGroupPrefix)-identity" -TemplateFile $templateFile -TemplateParameterFile $parameterFile  -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix  -Verbose -Location $Location


}
else {

    New-AzManagementGroupDeployment -ManagementGroupId "$($topLevelManagementGroupPrefix)-identity" -TemplateFile $templateFile -TemplateParameterFile $parameterFile  -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix  -Verbose -Location $Location



}
