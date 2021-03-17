# Change required

Edit button below to point to your repository use encode selection string to url change and then convert selection back to URL encoding
Need to be public as this uses gui. 

| Enterprise-Scale Design Principles | ARM Template | Scale without refactoring |
|:-------------|:--------------|:--------------|
|![Best Practice Check](https://azurequickstartsservice.blob.core.windows.net/badges/subscription-deployments/create-rg-lock-role-assignment/BestPracticeResult.svg)| [![Deploy To Azure](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.svg?sanitize=true)](https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fgithub.com%2FMathieuRietman%2Fes-changed%2Fblob%2Fmaster%2FarmTemplates%2Fes-hubspoke.json/createUIDefinitionUri/https://portal.azure.com/#blade/Microsoft_Azure_CreateUIDef/CustomDeploymentBlade/uri/https%3A%2F%2Fraw.githubusercontent.com%2FMathieuRietman%2Fes-changed%2Fmaster%2FarmTemplates%2Fportal-es-hubspoke.json)  | Yes |


Take latest code from your reference implementation https://github.com/Azure/Enterprise-Scale/tree/main/docs/reference


Change management group structure 

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


Changing Workspace names. 

In armTemplates\auxiliary\logAnalytics.json

Change
```json
                    "workspaceName": {
                        "value": "[concat('la-',parameters('topLevelManagementGroupPrefix'),'-prod-we')]"
                    },
                    "automationAccountName": {
                        "value": "[concat('aa-',parameters('topLevelManagementGroupPrefix'), '-prod-we')]"
                    },
```

In armTemplates\auxiliary\logAnalyticsSolutions.json

Change
```json
    "variables": {
        "laResourceId": "[toLower(concat('/subscriptions/', parameters('managementSubscriptionId'), '/resourceGroups/', parameters('topLevelManagementGroupPrefix'), '-mgmt', '/providers/Microsoft.OperationalInsights/workspaces/', 'la-', parameters('topLevelManagementGroupPrefix'), '-prod-we'))]",
```


In armTemplates\auxiliary\diagnosticsAndSecurity.json
Change 7 time
```json
    "parameters": {
                    "logAnalytics": {
                        
                        "value":"[toLower(concat('/subscriptions/', parameters('managementSubscriptionId'), '/resourceGroups/', parameters('topLevelManagementGroupPrefix'), '-mgmt', '/providers/Microsoft.OperationalInsights/workspaces/', 'la-', parameters('topLevelManagementGroupPrefix'), '-prod-we'))]",
                    },
```


For network change 

In armTemplates\auxiliary\hubspoke-connectivity.json
Change
```json
    "variables": {
        "vpngwname": "[concat('vpngw-',parameters('topLevelManagementGroupPrefix'), '-prod-we')]",
        "erGwName": "[concat('ergw-',parameters('topLevelManagementGroupPrefix'), '-prod-we')]",
        "rgName": "[concat('rg-',parameters('topLevelManagementGroupPrefix'), '-connectivity-prod-we')]",
        "hubName": "[concat('vnet-',parameters('topLevelManagementGroupPrefix'), 'hub-prod-we')]",
        "azVpnGwIpName": "[concat('pip-',variables('vpngwname'))]",
        "azVpnGwSubnetId": "[concat('/subscriptions/', parameters('connectivitySubscriptionId'), '/resourceGroups/', variables('rgName'),'/providers/Microsoft.Network/virtualNetworks/', variables('hubname'), '/subnets/GatewaySubnet')]",
        "azFwName": "[concat(parameters('topLevelManagementGroupPrefix'), '-fw-', parameters('location'))]",
        "azErGwIpName": "[concat('pip', variables('erGwName'))]",
        "azVpnGwPipId": "[concat('/subscriptions/', parameters('connectivitySubscriptionId'), '/resourceGroups/', variables('rgName'), '/providers/Microsoft.Network/publicIPAddresses/', variables('azVpnGwIpName'))]",
        "azFwIpName": "[concat('pip',variables('azFwName'))]",
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
        "hubResourceId": "[concat('/subscriptions/', parameters('connectivitySubscriptionId'), '/resourceGroups/', 'rg-',parameters('topLevelManagementGroupPrefix'), '-connectivity-prod-we', '-connectivity', '/providers/Microsoft.Network/virtualNetworks/', 'vnet-',parameters('topLevelManagementGroupPrefix'), 'hub-prod-we')]",
        "rbacNameForLz": "[guid(subscription().id)]",
```     




# Deploy Enterprise-Scale with hub and spoke architecture standard docs

The Enterprise-Scale architecture is modular by design and allow organizations to start with foundational landing zones that support their application portfolios and add hybrid connectivity with ExpressRoute or VPN when required. Alternatively, organizations can start with an Enterprise-Scale architecture based on the traditional hub and spoke network topology if customers require hybrid connectivity to on-premises locations from the begining.

This reference implementation also allows the deployment of platform services across Availability Zones (such as VPN or ExpressRoute gateways) to increase availability uptime of such services. 

## Customer profile

This reference implementation is ideal for customers that have started their Enterprise-Scale journey with an Enterprise-Scale foundation implementation and then there is a need to add connectivity on-premises datacenters and branch offices by using a traditional hub and spoke network architecture. This reference implementation is also well suited for customers who want to start with Landing Zones for their net new
deployment/development in Azure by implementing a network architecture based on the traditional hub and spoke network topology.

## How to evolve from Enterprise-Scale foundation

If customer started with a Enterprise-Scale foundation deployment, and if the business requirements changes over time, such as migration of on-premise applications to Azure that requires hybrid connectivity, you will simply create the **Connectivity** Subscription, place it into the **Platform > Connectivity** Management Group and assign Azure Policy for the hub and spoke network topology.

## Pre-requisites

To deploy this ARM template, your user/service principal must have Owner permission at the Tenant root.
See the following [instructions](https://docs.microsoft.com/en-us/azure/role-based-access-control/elevate-access-global-admin) on how to grant access.

### Optional prerequisites

The deployment experience in Azure portal allows you to bring in existing (preferably empty) subscriptions dedicated for platform management, connectivity and identity. It also allows you to bring existing subscriptions that can be used as the initial landing zones for your applications.

To learn how to create new subscriptions programatically, please visit this [link](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/programmatically-create-subscription?tabs=rest).

To learn how to create new subscriptions using Azure portal, please visit this [link](https://azure.microsoft.com/en-us/blog/create-enterprise-subscription-experience-in-azure-portal-public-preview/).

## What will be deployed?

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

## Next steps

### From an application perspective:

Once you have deployed the reference implementation, you can create new subscriptions, or move an existing subscriptions to the **Landing Zones** > **Online** or **Corp**  management group, and finally assign RBAC to the groups/users who should use the landing zones (subscriptions) so they can start deploying their workloads.

Refer to the [Create Landing Zone(s)](../../EnterpriseScale-Deploy-landing-zones.md) article for guidance to create Landing Zones.
