# Example to change naming convention in Enterprise scale 
<br>

The enterprise scale sample reference implementation [https://github.com/Azure/Enterprise-Scale](https://github.com/Azure/Enterprise-Scale) has a fixed naming convention and sometimes there is a wish to change this naming convention. 
<br>

This repository give an example how to accomplish this, we encourage always use infrastructure as code and also consider to adopt [azops](https://github.com/Azure/Enterprise-Scale/blob/main/docs/Deploy/getting-started.md).
As the reference implementation is kept up to date the knowledge and configuration is a good place to start and give you already xx% of governance set by policies and as so always interesting to take this as a starting point.
<br>

The repository document two approaches but there are always other approaches :
1. Change the templates and deploy via GUI as the reference implementation is working. 
<br>This require that your code is public as the deployment is via portal and the templates must be public accessible. Also the used parameters are then not part of your infrastructure as code.
2. Change the templates and deploy with parameter files that are then possible integrated with pipelines.
<br>Parameters can then be part of your code or variables in your pipeline.

There are always two steps 

1. Copy latest sources and modify the source to adopt your naming convention.
2. Deploy it either by modifing the GUI deployment button or via the deployment scripts with parameters files. See sample.

<br>
<br>

# Step 1 Modify the sources to adopt your naming convention
<br>

* Take latest code from your reference implementation https://github.com/Azure/Enterprise-Scale/tree/main/docs/reference
<br> In this repository a select the files under adventure works.


Edit then the files in armTemplates\auxiliary\ below you see an example of edited files.
### Step Change management group structure 
<br>
in file armTemplates\auxiliary\mgmtGroups.json

```json
    "platformMgs": {
            "type": "array",
            "defaultValue": [
                "management",
                "connectivity",
                "identity"
            ],
            "metadata": {
                "description": "Management groups for platform specific purposes, such as management, networking, identity etc."
            }
        },
        "landingZoneMgs": {
            "type": "array",
            "defaultValue": [
                "online",
                "corp"
            ],
            "metadata": {
                "description": "These are the landing zone management groups."
            }
        }
    },
    "variables": {
        "enterpriseScaleManagementGroups": {
            "platform": "[concat(parameters('topLevelManagementGroupPrefix'), '-', 'platform')]",
            "landingZone": "[concat(parameters('topLevelManagementGroupPrefix'), '-', 'landingzones')]",
            "decommissioned": "[concat(parameters('topLevelManagementGroupPrefix'), '-', 'decommissioned')]",
            "sandboxes": "[concat(parameters('topLevelManagementGroupPrefix'), '-', 'sandboxes')]"
        }
```

If required change move action in es-hubspoke.json
```json
   "moveSubscription": "[concat(parameters('enterpriseScaleCompanyPrefix'), '-management', '/', parameters('managementSubscriptionId'))]",
        "noSubscription": "[concat(parameters('enterpriseScaleCompanyPrefix'), '-management', '/', 'na')]",
        "noOnlineLzSubscription": "[concat(parameters('enterpriseScaleCompanyPrefix'), '-online', '/', 'nalz')]",
        "noCorpLzSubscription": "[concat(parameters('enterpriseScaleCompanyPrefix'), '-corp', '/', 'nalz')]",
        "noCorpConnectedLzSubscription": "[concat(parameters('enterpriseScaleCompanyPrefix'), '-corp', '/', 'naconnect')]",
        "connectivityMoveSubscription": "[concat(parameters('enterpriseScaleCompanyPrefix'), '-connectivity', '/', parameters('connectivitySubscriptionId'))]",
        "noConnectivitySubscription": "[concat(parameters('enterpriseScaleCompanyPrefix'), '-connectivity', '/', 'naconn')]",
        "identityMoveSubscription": "[concat(parameters('enterpriseScaleCompanyPrefix'), '-identity', '/', parameters('identitySubscriptionId'))]",
        "noIdentitySubscription": "[concat(parameters('enterpriseScaleCompanyPrefix'), '-identity', '/', 'naid')]",
```


### Step Changing Workspace names and resourcegroup. 

In armTemplates\auxiliary\logAnalytics.json

Change
```json
   "parameters": {
                    "workspaceName": {
                        "value": "[concat('la-',parameters('topLevelManagementGroupPrefix'),'-prod-we')]"  // change this
                    },
                    "automationAccountName": {
                        "value": "[concat('aa-',parameters('topLevelManagementGroupPrefix'), '-prod-we')]" // change this
                    },
                    "workspaceRegion": {
                        "value": "[deployment().location]"
                    },
                    "automationRegion": {
                        "value": "[deployment().location]"
                    },
                    "rgName": {
                        "value": "[concat('rg-', parameters('topLevelManagementGroupPrefix'), '-mgmt-prod-central')]"   // change this
                    },
                    "retentionInDays": {
                        "value": "[parameters('retentionInDays')]"
                    }
```

In armTemplates\auxiliary\logAnalyticsSolutions.json
```json
    "resources": [
        {
            "type": "Microsoft.Resources/deployments",
            "apiVersion": "2018-05-01",
            "name": "[take(concat('EntScale-', 'solutions-', guid(deployment().name)), 63)]",
            "resourceGroup": "[concat('rg-', parameters('topLevelManagementGroupPrefix'), '-mgmt-prod-central')]",  //change this
```

Change Parmeter in right naming
```json
  "workspaceName": {
            "type": "string",
            "defaultValue": "[concat('la-', parameters('topLevelManagementGroupPrefix'), '-prod-we')]",  //change this
            "metadata": {
                "description": "Provide resource name for the Log Analytics workspace. When deployed using ES RI, this name it provided deterministically based on ESLZ prefix."
            }
        },
```

Change
```json
   "variables": {
        "laResourceId": "[toLower(concat('/subscriptions/', parameters('managementSubscriptionId'), '/resourceGroups/', 'rg-', parameters('topLevelManagementGroupPrefix'), '-mgmt-prod-central', '/providers/Microsoft.OperationalInsights/workspaces/', 'la-', parameters('topLevelManagementGroupPrefix'), '-prod-we'))]", //change this


```


In armTemplates\auxiliary\diagnosticsAndSecurity.json
Change 7 time
```json
    "parameters": {
                    "logAnalytics": {
                        
                        "value":"[toLower(concat('/subscriptions/', parameters('managementSubscriptionId'), '/resourceGroups/','rg-', parameters('topLevelManagementGroupPrefix'), '-mgmt-prod-central', '/providers/Microsoft.OperationalInsights/workspaces/', 'la-', parameters('topLevelManagementGroupPrefix'), '-prod-we'))]",  //change this
                    },
```


## Step For network naming convention changes 

In armTemplates\auxiliary\hubspoke-connectivity.json
Change
```json
    "variables": {
        "vpngwname": "[concat('vpngw-',parameters('topLevelManagementGroupPrefix'), '-prod-we')]",    //change this
        "erGwName": "[concat('ergw-',parameters('topLevelManagementGroupPrefix'), '-prod-we')]",   //change this
        "rgName": "[concat('rg-',parameters('topLevelManagementGroupPrefix'), '-connectivity-prod-we')]",   //change this
        "hubName": "[concat('vnet-',parameters('topLevelManagementGroupPrefix'), 'hub-prod-we')]",   //change this
        "azVpnGwIpName": "[concat('pip-',variables('vpngwname'))]",  //change this
        "azVpnGwSubnetId": "[concat('/subscriptions/', parameters('connectivitySubscriptionId'), '/resourceGroups/', variables('rgName'),'/providers/Microsoft.Network/virtualNetworks/', variables('hubname'), '/subnets/GatewaySubnet')]",
        "azFwName": "[concat('fw-', parameters('topLevelManagementGroupPrefix'), '-prod-we')]",  //change this
        "azErGwIpName": "[concat('pip-', variables('erGwName'))]", //change this
        "azVpnGwPipId": "[concat('/subscriptions/', parameters('connectivitySubscriptionId'), '/resourceGroups/', variables('rgName'), '/providers/Microsoft.Network/publicIPAddresses/', variables('azVpnGwIpName'))]",
        "azFwIpName": "[concat('pip-',variables('azFwName'))]", //change this
        "azErGwSubnetId": "[concat('/subscriptions/', parameters('connectivitySubscriptionId'), '/resourceGroups/', variables('rgName'),'/providers/Microsoft.Network/virtualNetworks/', variables('hubname'), '/subnets/GatewaySubnet')]",
        "azErGwPipId": "[concat('/subscriptions/', parameters('connectivitySubscriptionId'), '/resourceGroups/', variables('rgName'), '/providers/Microsoft.Network/publicIPAddresses/', variables('azErGwIpName'))]",
        "azFwSubnetId": "[concat('/subscriptions/', parameters('connectivitySubscriptionId'), '/resourceGroups/', variables('rgName'),'/providers/Microsoft.Network/virtualNetworks/', variables('hubname'), '/subnets/AzureFirewallSubnet')]",
        "azFwPipId": "[concat('/subscriptions/', parameters('connectivitySubscriptionId'), '/resourceGroups/', variables('rgName'), '/providers/Microsoft.Network/publicIPAddresses/', variables('azFwIpName'))]",
        "resourceDeploymentName": "[take(concat(deployment().name, '-hubspoke'), 64)]",
        // Creating variable that later will be used in conjunction with the union() function to cater for conditional subnet creation while ensuring idempotency
```
In armTemplates\auxiliary\corp-policy-peering.json

Change
```json
  "variables": {
        "hubResourceId": "[concat('/subscriptions/', parameters('connectivitySubscriptionId'), '/resourceGroups/', 'rg-',parameters('topLevelManagementGroupPrefix'), '-connectivity-prod-we', '/providers/Microsoft.Network/virtualNetworks/', 'vnet-',parameters('topLevelManagementGroupPrefix'), 'hub-prod-we')]",  //change this
  
```     


<br>
<br>
<br>

# 2 Deploy via deployment script with parameters.


In the folder scrips [Scripts](./scripts) there are scripts created for every deployment with in [Parameters](./scripts/parameters) also the parameters that else are specified by the GUI.

```ps1
# Management Groups
.\step1DeployMgmtGroups.ps1 -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix  -Location  $Location
# Custom Policies deployment to the top level management group
.\step2DeployPolicies.ps1 -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix  -Location  $Location
# Log Analytics Automation Account policy assignment and deploy
.\step3DeployLogAnalytics.ps1 -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix  -Location  $Location -managementSubscriptionId $managementSubscriptionId 
# Deploy Log Analytics Solutions
.\step4DeployLogAnalyticsSolutions.ps1 -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix  -Location  $Location -managementSubscriptionId $managementSubscriptionId 
# Identity policies assignment
.\step5DeployIdentity.ps1 -topLevelManagementGroupPrefix  $topLevelManagementGroupPrefix  -Location  $Location
# LandingZone policies assignment
.\step6DeployLz.ps1  -topLevelManagementGroupPrefix  $topLevelManagementGroupPrefix  -Location  $Location
# TopLevel Diagnostic and security policies assignment
.\step7DeploydiagnosticsAndSecurity.ps1 -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix  -Location  $Location -managementSubscriptionId $managementSubscriptionId 
# Deploy Connectivity FW, VPNGW
.\step8Deployhubspoke-connectivity.ps1 -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix  -Location  $Location -connectivitySubscriptionId $connectivitySubscriptionId
# Sample of SPoke vNet policy assignment and deploy
.\step9DeployCorp-policy-peering.ps1 -topLevelManagementGroupPrefix $topLevelManagementGroupPrefix  -Location  $Location -connectivitySubscriptionId $connectivitySubscriptionId -CorpSubscriptionId $CorpSubscriptionId  
```	   


# 3 Deploy via Azure Portal GUI. Modify the deploy button to deploy via a public Git Hub.

Edit button below to point to your repository use encode selection string to url change and then convert selection back to URL encoding.


This needs that your repository need to be public assessable, and that your parameters and choices you choose are not part of the code.

edit https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-changed%2Fmaster%2FarmTemplates%2Fes-hubspoke.json and https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-changed%2Fmaster%2FarmTemplates%2Fportal-es-hubspoke.json that should point to your repository.

Commit changes and use button in github.

| Enterprise-Scale Design Principles                                                                                                                                  | ARM Template                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | Scale without refactoring |
| :------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------ |
| ![Best Practice Check](https://azurequickstartsservice.blob.core.windows.net/badges/subscription-deployments/create-rg-lock-role-assignment/BestPracticeResult.svg) | [![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-changed%2Fmaster%2FarmTemplates%2Fes-hubspoke.json/createUIDefinitionUri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-changed%2Fmaster%2FarmTemplates%2Fportal-es-hubspoke.json) | Yes                       |

<br>
<br>




<br>
<br>
<br>

<br>
<br>
<br>

## Reference 

This Sample is the Enterprise Landing Zone reference implementation of adventure works copied on 17 March 2021

<br>

### What will be deployed?

By default, all recommendations are enabled and you must explicitly disable them if you don't want it to be deployed and configured.

- A scalable Management Group hierarchy aligned to core platform capabilities, allowing you to operationalize at scale using centrally managed Azure RBAC and Azure Policy where platform and workloads have clear separation.
- Azure Policies that will enable autonomy for the platform and the landing zones.
- An Azure subscription dedicated for **management**, which enables core platform capabilities at scale using Azure Policy such as:
  - A Log Analytics workspace and an Automation account
  - Azure Security Center monitoring
  - Azure Security Center (Standard or Free tier)
  - Azure Sentinel
  - Diagnostics settings for Activity Logs, VMs, and PaaS resources sent to Log Analytics
- An Azure subscription dedicated for **connectivity**, which deploys core Azure networking resources such as:
  - A hub virtual network
  - Azure Firewall (optional - deployment across Availability Zones)
  - ExpressRoute Gateway (optional - deployment across Availability Zones)
  - VPN Gateway (optional - deployment across Availability Zones)
  - Azure Private DNS Zones for Private Link
- (Optionally) An Azure subscription dedicated for **identity** in case your organization requires to have Active Directory Domain Controllers in a dedicated subscription.
- Landing Zone Management Group for **corp** connected applications that require connectivity to on-premises, to other landing zones or to the internet via shared services provided in the hub virtual network.
  - This is where you will create your subscriptions that will host your corp-connected workloads.
- Landing Zone Management Group for **online** applications that will be internet-facing, where a virtual network is optional and hybrid connectivity is not required.
  - This is where you will create your Subscriptions that will host your online workloads.
- Landing zone subscriptions for Azure native, internet-facing **online** applications and resources.
- Landing zone subscriptions for **corp** connected applications and resources, including a virtual network that will be connected to the hub via VNet peering.
- Azure Policies for online and corp-connected landing zones, which include:
  - Enforce VM monitoring (Windows & Linux)
  - Enforce VMSS monitoring (Windows & Linux)
  - Enforce Azure Arc VM monitoring (Windows & Linux)
  - Enforce VM backup (Windows & Linux)
  - Enforce secure access (HTTPS) to storage accounts
  - Enforce auditing for Azure SQL
  - Enforce encryption for Azure SQL
  - Prevent IP forwarding
  - Prevent inbound RDP from internet
  - Ensure subnets are associated with NSG

![Enterprise-Scale with connectivity](./media/es-hubspoke.png)