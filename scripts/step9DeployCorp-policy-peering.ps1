<#
	.SYNOPSIS
        1. Deploy the Connect-Vnet-to-hub policy that create Vnet and Peering in  an spoke vNet to a subscription as as an example.
         Normal is corp-policy-peering.json that has an object of subscription and addresses and use linked template corp-policy-peering.json
         This sample is just corp-policy-peering.json as linked templates require then also public access or key and we do not want to modify to much the standard reference templates 
        Copy files from an reference implementation https://github.com/Azure/Enterprise-Scale/tree/main/docs/reference this sample is based on Advantureworks.
        Most reference implementation use same files.

        As the policy is based on naming convention in variable it is less easy to customize withud adding additional parameters like vnetName or workload name.



	.DESCRIPTION

    Connect-AzAccount
    As this is and Subscription deployment you should have deployment rights on subscription level specified and on the cnnectivity subscription for the peering. 
    Add the 
   

	.EXAMPLE
	   .\step8Deploycorp-policy-peering.ps1 -topLevelManagementGroupPrefix "test6" -Location  "WestEurope" -connectivitySubscriptionId  "xxxxxxx-xxxxx-x-xxxxxx"  -CorpSubscriptionId  "xxxxxxx-xxxxx-x-xxxxxx" 
	   
	.LINK

	.Notes
		NAME:      step8Deploycorp-policy-peering.ps1
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
    $connectivitySubscriptionId,
    [Parameter(Mandatory = $true)]
    [string]
    $CorpSubscriptionId  
    
)
$ErrorActionPreference = "Stop"

$root = $PSScriptRoot

$deployFile = "corp-policy-peering"
$templateFile = "$($root)/../armTemplates/auxiliary/$($deployFile).json"
$parameterFile = "$($root)/parameters/$($deployFile).parameters.json"


# first select the right subscription for deployment

Try { 
    Set-AzContext -SubscriptionId  $CorpSubscriptionId  
} 
catch {
    throw $_
}

Write-Host "Start create network in provided subscription corp "

If (Test-Path -Path $parameterFile ) {
    New-AzDeployment -TemplateFile $templateFile -TemplateParameterFile $parameterFile  -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix -connectivitySubscriptionId $connectivitySubscriptionId  -Verbose -Location $Location -locationFromTemplate $location
}
else {
    New-AzDeployment  -TemplateFile $templateFile -TemplateParameterFile $parameterFile  -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix -connectivitySubscriptionId $connectivitySubscriptionId  -Verbose -Location $Location -locationFromTemplate $location
}
