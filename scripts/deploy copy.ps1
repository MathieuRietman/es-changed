#Connect-AzAccount
#  Make sure you have root inherent 
#  New-AzRoleAssignment -ObjectId <userobeject ID that run the script> -RoleDefinitionName Owner -Scope /        

$connectivitySubscriptionId = "f722405b-c3f6-4477-954d-1073c53e3726" 
$managementSubscriptionId =  "b256fd43-0eec-4c6c-ace9-69d01025efb7" 
$landingzoneSUbscriptionID =  "48baa7a2-1f20-42bf-818d-052cb685ee23" 
$topLevelManagementGroupPrefix = "umcg"
$topLevelManagementGroupdisplayName ="umcg"
$Location = "WestEurope"
$enableResourceDeployments = "Yes"

#Based on ENterprise scale 

#create Management groupmanagement group
Write-Host "Start create management group"
New-AzTenantDeployment -TemplateFile ./ManagementGroups.json -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix -topLevelManagementGroupdisplayName $topLevelManagementGroupdisplayName -Verbose -Location $Location



#deploy Policies to top management Group
Write-Host "Start deploy policy definitions to toplevel Management Group"
New-AzManagementGroupDeployment -TemplateFile ./policies.json -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix -ManagementGroupId "$($topLevelManagementGroupPrefix)" -Verbose -Location $Location 




#deploy umcg specific Policies 
Write-Host "Start deploy umcg specific  policy definitions sets"

New-AzManagementGroupDeployment -TemplateFile ./umcg.policies.json -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix -ManagementGroupId "$($topLevelManagementGroupPrefix)" -Verbose -Location $Location 


Exit
