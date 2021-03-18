<#
	.SYNOPSIS
        1. Deploy All via scripts instead of modify using parameter file located in ./parameters
        Copy files from an reference implementation https://github.com/Azure/Enterprise-Scale/tree/main/docs/reference this sample is based on Advantureworks.
        


	.DESCRIPTION

    Connect-AzAccount
    As these deployment have tenant deployment / Management group deployment and subscription deployment make sure you have root inherent 
    New-AzRoleAssignment -ObjectId <userobeject ID that run the script> -RoleDefinitionName Owner -Scope /    
   

	.EXAMPLE
	   .\deploAll.ps1 -topLevelManagementGroupPrefix "test6" -Location  "WestEurope" -managementSubscriptionId "xxxxxxxx-xxxxxx-xxxxxx" -connectivitySubscriptionId  "xxxxxxx-xxxxx-x-xxxxxx" -CorpSubscriptionId "xxxxxxx-xxxxx-x-xxxxxx"
	   
	.LINK

	.Notes
		NAME:      deploAll.ps1
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
    $managementSubscriptionId, 
    [Parameter(Mandatory = $true)]
    [string]
    $connectivitySubscriptionId, 
    [Parameter(Mandatory = $true)]
    [string]
    $CorpSubscriptionId  

)

$root = $PSScriptRoot
# Management Groups
& $root\step1DeployMgmtGroups.ps1 -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix  -Location  $Location
# Custom Policies deployment to the top level management group
& $root\step2DeployPolicies.ps1 -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix  -Location  $Location
# Log Analytics Automation Account policy assignment and deploy
& $root\step3DeployLogAnalytics.ps1 -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix  -Location  $Location -managementSubscriptionId $managementSubscriptionId 
# Deploy Log Analytics Solutions
& $root\step4DeployLogAnalyticsSolutions.ps1 -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix  -Location  $Location -managementSubscriptionId $managementSubscriptionId 
# Identity policies assignment
& $root\step5DeployIdentity.ps1 -topLevelManagementGroupPrefix  $topLevelManagementGroupPrefix  -Location  $Location
# LandingZone policies assignment
& $root\step6DeployLz.ps1  -topLevelManagementGroupPrefix  $topLevelManagementGroupPrefix  -Location  $Location
# TopLevel Diagnostic and security policies assignment
& $root\step7DeploydiagnosticsAndSecurity.ps1 -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix  -Location  $Location -managementSubscriptionId $managementSubscriptionId 
# Deploy Connectivity FW, VPNGW
& $root\step8Deployhubspoke-connectivity.ps1 -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix  -Location  $Location -connectivitySubscriptionId $connectivitySubscriptionId
# Sample of SPoke vNet policy assignment and deploy
& $root\step9DeployCorp-policy-peering.ps1 -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix  -Location  $Location -connectivitySubscriptionId $connectivitySubscriptionId -CorpSubscriptionId $CorpSubscriptionId  
	   