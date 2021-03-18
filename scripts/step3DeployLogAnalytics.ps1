<#
	.SYNOPSIS
        1. Deploy the Log Analytics and automation account via an policy assigned to <toplevel>-management Group, also policy is used to validate compliance of this management group.
        Copy files from an reference implementation https://github.com/Azure/Enterprise-Scale/tree/main/docs/reference this sample is based on Advantureworks.
        Most reference implementation use same files.



	.DESCRIPTION

    Connect-AzAccount
    As this is and managementgroup deployment you should have deployment rights on managementgroup level specified. 
   

	.EXAMPLE
	   .\step3DeployLogAnalytics.ps1-topLevelManagementGroupPrefix "test6" -Location  "WestEurope" -managementSubscriptionId "xxxxx-xxxxxx-xxxxxx-xxxxxx"
	   
	.LINK

	.Notes
		NAME:      step3DeployLogAnalytics.ps1
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
    [Parameter(Mandatory = $true)]
    [string]
    $managementSubscriptionId 

    
)


$root = $PSScriptRoot

$deployFile = "logAnalytics"
$templateFile = "$($root)/../armTemplates/auxiliary/$($deployFile).json"
$parameterFile = "$($root)/parameters/$($deployFile).parameters.json"

## first move the $managementSubscriptionId to the right management group

New-AzManagementGroupSubscription -GroupId "$($topLevelManagementGroupPrefix)-management" -SubscriptionId $managementSubscriptionId 


Write-Host "Start create Log analytics and automation account"
If (Test-Path -Path $parameterFile ) {

    New-AzManagementGroupDeployment -ManagementGroupId "$($topLevelManagementGroupPrefix)-management" -TemplateFile $templateFile -TemplateParameterFile $parameterFile  -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix -managementSubscriptionId $managementSubscriptionId   -Verbose -Location $Location


}
else {

    New-AzManagementGroupDeployment -ManagementGroupId "$($topLevelManagementGroupPrefix)-management" -TemplateFile $templateFile -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix -managementSubscriptionId $managementSubscriptionId   -Verbose -Location $Location



}
