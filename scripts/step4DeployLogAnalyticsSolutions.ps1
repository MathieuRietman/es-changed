<#
	.SYNOPSIS
        1. Deploy the Log Analytics solution to an existing Log Analytics that is created via policy
        Copy files from an reference implementation https://github.com/Azure/Enterprise-Scale/tree/main/docs/reference this sample is based on Advantureworks.
        Most reference implementation use same files.



	.DESCRIPTION

    Connect-AzAccount
    As this is and subscription deployment you should have deployment rights on managementgroup level specified. 
   

	.EXAMPLE
	   .\step4DeploylogAnalyticsSolutions.ps1 -topLevelManagementGroupPrefix "test6" -Location  "WestEurope" -managementSubscriptionId "xxxxxxxx-xxxxxx-xxxxxx"
	   
	.LINK

	.Notes
		NAME:      step4DeploylogAnalyticsSolutions.ps1
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

$deployFile = "logAnalyticsSolutions"
$templateFile = "$($root)/../armTemplates/auxiliary/$($deployFile).json"
$parameterFile = "$($root)/parameters/$($deployFile).parameters.json"

$workspaceName = "la-$($topLevelManagementGroupPrefix)-prod-we"

Set-AzContext -SubscriptionId $managementSubscriptionId 

Write-Host "Start create solutions to existing LA"
If (Test-Path -Path $parameterFile ) {

    New-AzDeployment  -TemplateFile $templateFile -TemplateParameterFile $parameterFile  -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix -managementSubscriptionId $managementSubscriptionId -workspaceName $workspaceName -workspaceRegion $Location -Verbose -Location $Location


}
else {

    New-AzDeployment -TemplateFile $templateFile -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix -managementSubscriptionId $managementSubscriptionId  -workspaceName $workspaceName -workspaceRegion $Location -Verbose -Location $Location



}
