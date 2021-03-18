<#
	.SYNOPSIS
        1. Deploy Connectivity VPNGW firewall etc. 
        Copy files from an reference implementation https://github.com/Azure/Enterprise-Scale/tree/main/docs/reference this sample is based on Advantureworks.
        Most reference implementation use same files.



	.DESCRIPTION

    Connect-AzAccount
    As this is and Subscription deployment you should have deployment rights on subscription level specified
    
   

	.EXAMPLE
	   .\step8Deployhubspoke-connectivity.ps1 -topLevelManagementGroupPrefix "test6" -Location  "WestEurope" -connectivitySubscriptionId  "xxxxxxx-xxxxx-x-xxxxxx" 
	   
	.LINK

	.Notes
		NAME:      step8Deployhubspoke-connectivity.ps1
		AUTHOR(s): Mathieu Rietman <marietma@microsoft.com>
		LASTEDIT:  03/18/2021
		KEYWORDS:  eslz connectivity managemengroup
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
    $connectivitySubscriptionId 


    
)
$root = $PSScriptRoot
$ErrorActionPreference = "Stop"
$deployFile = "hubspoke-connectivity"
$templateFile = "$($root)/../armTemplates/auxiliary/$($deployFile).json"
$parameterFile = "$($root)/parameters/$($deployFile).parameters.json"

## first select the right subscription for deployment
Try { 
    Set-AzContext -SubscriptionId $connectivitySubscriptionId 
} 
catch {
    throw $_
}


## Move first the subscription to the right management group

New-AzManagementGroupSubscription -GroupId "$($topLevelManagementGroupPrefix)-connectivity" -SubscriptionId $connectivitySubscriptionId 

Write-Host "Start assign policies to top Management group"
If (Test-Path -Path $parameterFile ) {
    New-AzDeployment -TemplateFile $templateFile -TemplateParameterFile $parameterFile  -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix -connectivitySubscriptionId $connectivitySubscriptionId  -Verbose -Location $Location
}
else {
    New-AzDeployment  -TemplateFile $templateFile -TemplateParameterFile $parameterFile  -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix -connectivitySubscriptionId $connectivitySubscriptionId  -Verbose -Location $Location
}
