### Creating storage account, app insights and azure function app using azure cli

1. Create resource group 

```
az group create 
    --name azure-lohika-rg 
    --location eastus
```

```json
{
  "id": "/subscriptions/391264ae-2d45-4841-99e6-ef8bb8787ef7/resourceGroups/azure-lohika-rg",
  "location": "eastus",
  "managedBy": null,
  "name": "azure-lohika-rg",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
```

2. Create storage account
```
az storage account create 
    --name ozstoaacclohika  
    --resource-group azure-lohika-rg 
    --kind StorageV2 
    --location eastus 
    --sku Standard_LRS
```

```json
{
  "accessTier": "Hot",
  "allowBlobPublicAccess": true,
  "allowCrossTenantReplication": null,
  "allowSharedKeyAccess": null,
  "allowedCopyScope": null,
  "azureFilesIdentityBasedAuthentication": null,
  "blobRestoreStatus": null,
  "creationTime": "2022-07-01T09:32:39.734949+00:00",
  "customDomain": null,
  "defaultToOAuthAuthentication": null,
  "dnsEndpointType": null,
  "enableHttpsTrafficOnly": true,
  "enableNfsV3": null,
  "encryption": {
    "encryptionIdentity": null,
    "keySource": "Microsoft.Storage",
    "keyVaultProperties": null,
    "requireInfrastructureEncryption": null,
    "services": {
      "blob": {
        "enabled": true,
        "keyType": "Account",
        "lastEnabledTime": "2022-07-01T09:32:39.859932+00:00"
      },
      "file": {
        "enabled": true,
        "keyType": "Account",
        "lastEnabledTime": "2022-07-01T09:32:39.859932+00:00"
      },
      "queue": null,
      "table": null
    }
  },
  "extendedLocation": null,
  "failoverInProgress": null,
  "geoReplicationStats": null,
  "id": "/subscriptions/391264ae-2d45-4841-99e6-ef8bb8787ef7/resourceGroups/azure-lohika-rg/providers/Microsoft.Storage/storageAccounts/ozstoaacclohika",
  "identity": null,
  "immutableStorageWithVersioning": null,
  "isHnsEnabled": null,
  "isLocalUserEnabled": null,
  "isSftpEnabled": null,
  "keyCreationTime": {
    "key1": "2022-07-01T09:32:39.859932+00:00",
    "key2": "2022-07-01T09:32:39.859932+00:00"
  },
  "keyPolicy": null,
  "kind": "StorageV2",
  "largeFileSharesState": null,
  "lastGeoFailoverTime": null,
  "location": "eastus",
  "minimumTlsVersion": "TLS1_0",
  "name": "ozstoaacclohika",
  "networkRuleSet": {
    "bypass": "AzureServices",
    "defaultAction": "Allow",
    "ipRules": [],
    "resourceAccessRules": null,
    "virtualNetworkRules": []
  },
  "primaryEndpoints": {
    "blob": "https://ozstoaacclohika.blob.core.windows.net/",
    "dfs": "https://ozstoaacclohika.dfs.core.windows.net/",
    "file": "https://ozstoaacclohika.file.core.windows.net/",
    "internetEndpoints": null,
    "microsoftEndpoints": null,
    "queue": "https://ozstoaacclohika.queue.core.windows.net/",
    "table": "https://ozstoaacclohika.table.core.windows.net/",
    "web": "https://ozstoaacclohika.z13.web.core.windows.net/"
  },
  "primaryLocation": "eastus",
  "privateEndpointConnections": [],
  "provisioningState": "Succeeded",
  "publicNetworkAccess": null,
  "resourceGroup": "azure-lohika-rg",
  "routingPreference": null,
  "sasPolicy": null,
  "secondaryEndpoints": null,
  "secondaryLocation": null,
  "sku": {
    "name": "Standard_LRS",
    "tier": "Standard"
  },
  "statusOfPrimary": "available",
  "statusOfSecondary": null,
  "storageAccountSkuConversionStatus": null,
  "tags": {},
  "type": "Microsoft.Storage/storageAccounts"
}
```


3. Create app insights for monitoring
```
az monitor app-insights component create 
    --app AppInsights 
    --location eastus 
    --kind web 
    --resource-group azure-lohika-rg 
    --application-type web
```

```json
{
  "appId": "97d4efca-f622-41f8-b85b-bccc527678ab",
  "applicationId": "AppInsights",
  "applicationType": "web",
  "connectionString": "InstrumentationKey=7c5c9d61-50f1-46c2-84f8-658e19e44470;IngestionEndpoint=https://eastus-6.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus.livediagnostics.monitor.azure.com/",
  "creationDate": "2022-07-01T09:41:15.676268+00:00",
  "disableIpMasking": null,
  "etag": "\"5c00c56d-0000-0100-0000-62bec13b0000\"",
  "flowType": "Bluefield",
  "hockeyAppId": null,
  "hockeyAppToken": null,
  "id": "/subscriptions/391264ae-2d45-4841-99e6-ef8bb8787ef7/resourceGroups/azure-lohika-rg/providers/microsoft.insights/components/AppInsights",
  "immediatePurgeDataOn30Days": null,
  "ingestionMode": "ApplicationInsights",
  "instrumentationKey": "7c5c9d61-50f1-46c2-84f8-658e19e44470",
  "kind": "web",
  "location": "eastus",
  "name": "AppInsights",
  "privateLinkScopedResources": null,
  "provisioningState": "Succeeded",
  "publicNetworkAccessForIngestion": "Enabled",
  "publicNetworkAccessForQuery": "Enabled",
  "requestSource": "rest",
  "resourceGroup": "azure-lohika-rg",
  "retentionInDays": 90,
  "samplingPercentage": null,
  "tags": {},
  "tenantId": "391264ae-2d45-4841-99e6-ef8bb8787ef7",
  "type": "microsoft.insights/components"
}
```

4. List available function dotnet runtimes for windows
```
az functionapp list-runtimes 
    --query "windows[?runtime=='dotnet']"
```

```json
[
  {
    "runtime": "dotnet",
    "supported_functions_versions": [
      "4"
    ],
    "version": "6"
  },
  {
    "runtime": "dotnet",
    "supported_functions_versions": [
      "3"
    ],
    "version": "3.1"
  }
]

```

5. Create app service plan for function app
```
az appservice plan create 
    --name FunctionPlan 
    --resource-group azure-lohika-rg 
    --location eastus 
    --sku S1
```

```json
{
  "elasticScaleEnabled": false,
  "extendedLocation": null,
  "freeOfferExpirationTime": null,
  "geoRegion": "East US",
  "hostingEnvironmentProfile": null,
  "hyperV": false,
  "id": "/subscriptions/391264ae-2d45-4841-99e6-ef8bb8787ef7/resourceGroups/azure-lohika-rg/providers/Microsoft.Web/serverfarms/FunctionPlan",
  "isSpot": false,
  "isXenon": false,
  "kind": "app",
  "kubeEnvironmentProfile": null,
  "location": "eastus",
  "maximumElasticWorkerCount": 1,
  "maximumNumberOfWorkers": 0,
  "name": "FunctionPlan",
  "numberOfSites": 0,
  "perSiteScaling": false,
  "provisioningState": "Succeeded",
  "reserved": false,
  "resourceGroup": "azure-lohika-rg",
  "sku": {
    "capabilities": null,
    "capacity": 1,
    "family": "S",
    "locations": null,
    "name": "S1",
    "size": "S1",
    "skuCapacity": null,
    "tier": "Standard"
  },
  "spotExpirationTime": null,
  "status": "Ready",
  "subscription": "391264ae-2d45-4841-99e6-ef8bb8787ef7",
  "tags": null,
  "targetWorkerCount": 0,
  "targetWorkerSizeId": 0,
  "type": "Microsoft.Web/serverfarms",
  "workerTierName": null,
  "zoneRedundant": false
}
```

6. Create function app 
```
az functionapp create 
    --resource-group azure-lohika-rg 
    --name fn-olehzazure 
    --storage-account ozstoaacclohika 
    --runtime dotnet 
    --runtime-version 6 
    --app-insights AppInsights 
    --app-insights-key 7c5c9d61-50f1-46c2-84f8-658e19e44470  
    --os-type Windows 
    --plan FunctionPlan 
    --functions-version 4
```

```json
{
  "availabilityState": "Normal",
  "clientAffinityEnabled": false,
  "clientCertEnabled": false,
  "clientCertExclusionPaths": null,
  "clientCertMode": "Required",
  "cloningInfo": null,
  "containerSize": 1536,
  "customDomainVerificationId": "7796ADAEEDBCB641256121117E44C720E776AFE2CDD3B02CB740CD26CF41680A",
  "dailyMemoryTimeQuota": 0,
  "defaultHostName": "fn-olehzazure.azurewebsites.net",
  "enabled": true,
  "enabledHostNames": [
    "fn-olehzazure.azurewebsites.net",
    "fn-olehzazure.scm.azurewebsites.net"
  ],
  "extendedLocation": null,
  "hostNameSslStates": [
    {
      "hostType": "Standard",
      "ipBasedSslResult": null,
      "ipBasedSslState": "NotConfigured",
      "name": "fn-olehzazure.azurewebsites.net",
      "sslState": "Disabled",
      "thumbprint": null,
      "toUpdate": null,
      "toUpdateIpBasedSsl": null,
      "virtualIp": null
    },
    {
      "hostType": "Repository",
      "ipBasedSslResult": null,
      "ipBasedSslState": "NotConfigured",
      "name": "fn-olehzazure.scm.azurewebsites.net",
      "sslState": "Disabled",
      "thumbprint": null,
      "toUpdate": null,
      "toUpdateIpBasedSsl": null,
      "virtualIp": null
    }
  ],
  "hostNames": [
    "fn-olehzazure.azurewebsites.net"
  ],
  "hostNamesDisabled": false,
  "hostingEnvironmentProfile": null,
  "httpsOnly": false,
  "hyperV": false,
  "id": "/subscriptions/391264ae-2d45-4841-99e6-ef8bb8787ef7/resourceGroups/azure-lohika-rg/providers/Microsoft.Web/sites/fn-olehzazure",
  "identity": null,
  "inProgressOperationId": null,
  "isDefaultContainer": null,
  "isXenon": false,
  "keyVaultReferenceIdentity": "SystemAssigned",
  "kind": "functionapp",
  "lastModifiedTimeUtc": "2022-07-01T11:37:21.613333",
  "location": "East US",
  "maxNumberOfWorkers": null,
  "name": "fn-olehzazure",
  "outboundIpAddresses": "20.62.213.24,20.62.213.51,20.62.213.68,20.62.213.208,20.62.215.25,20.62.215.42,20.119.0.16",
  "possibleOutboundIpAddresses": "20.62.213.24,20.62.213.51,20.62.213.68,20.62.213.208,20.62.215.25,20.62.215.42,20.62.215.73,20.62.215.79,20.62.215.101,20.62.215.105,20.62.215.112,20.62.215.118,20.62.215.126,20.62.215.133,20.62.215.204,52.151.216.19,52.151.216.47,20.62.209.249,52.151.216.69,20.62.211.176,52.151.216.111,52.151.216.113,52.151.216.144,52.151.216.146,52.151.216.157,52.151.216.188,52.151.216.220,52.151.216.223,52.151.216.237,52.151.217.9,20.119.0.16",
  "redundancyMode": "None",
  "repositorySiteName": "fn-olehzazure",
  "reserved": false,
  "resourceGroup": "azure-lohika-rg",
  "scmSiteAlsoStopped": false,
  "serverFarmId": "/subscriptions/391264ae-2d45-4841-99e6-ef8bb8787ef7/resourceGroups/azure-lohika-rg/providers/Microsoft.Web/serverfarms/FunctionPlan",
  "siteConfig": {
    "acrUseManagedIdentityCreds": false,
    "acrUserManagedIdentityId": null,
    "alwaysOn": false,
    "antivirusScanEnabled": null,
    "apiDefinition": null,
    "apiManagementConfig": null,
    "appCommandLine": null,
    "appSettings": null,
    "autoHealEnabled": null,
    "autoHealRules": null,
    "autoSwapSlotName": null,
    "azureMonitorLogCategories": null,
    "azureStorageAccounts": null,
    "connectionStrings": null,
    "cors": null,
    "customAppPoolIdentityAdminState": null,
    "customAppPoolIdentityTenantState": null,
    "defaultDocuments": null,
    "detailedErrorLoggingEnabled": null,
    "documentRoot": null,
    "experiments": null,
    "fileChangeAuditEnabled": null,
    "ftpsState": null,
    "functionAppScaleLimit": 0,
    "functionsRuntimeScaleMonitoringEnabled": null,
    "handlerMappings": null,
    "healthCheckPath": null,
    "http20Enabled": false,
    "http20ProxyFlag": null,
    "httpLoggingEnabled": null,
    "ipSecurityRestrictions": [
      {
        "action": "Allow",
        "description": "Allow all access",
        "headers": null,
        "ipAddress": "Any",
        "name": "Allow all",
        "priority": 1,
        "subnetMask": null,
        "subnetTrafficTag": null,
        "tag": null,
        "vnetSubnetResourceId": null,
        "vnetTrafficTag": null
      }
    ],
    "javaContainer": null,
    "javaContainerVersion": null,
    "javaVersion": null,
    "keyVaultReferenceIdentity": null,
    "limits": null,
    "linuxFxVersion": "",
    "loadBalancing": null,
    "localMySqlEnabled": null,
    "logsDirectorySizeLimit": null,
    "machineKey": null,
    "managedPipelineMode": null,
    "managedServiceIdentityId": null,
    "metadata": null,
    "minTlsCipherSuite": null,
    "minTlsVersion": null,
    "minimumElasticInstanceCount": 0,
    "netFrameworkVersion": null,
    "nodeVersion": null,
    "numberOfWorkers": 1,
    "phpVersion": null,
    "powerShellVersion": null,
    "preWarmedInstanceCount": null,
    "publicNetworkAccess": null,
    "publishingPassword": null,
    "publishingUsername": null,
    "push": null,
    "pythonVersion": null,
    "remoteDebuggingEnabled": null,
    "remoteDebuggingVersion": null,
    "requestTracingEnabled": null,
    "requestTracingExpirationTime": null,
    "routingRules": null,
    "runtimeADUser": null,
    "runtimeADUserPassword": null,
    "scmIpSecurityRestrictions": [
      {
        "action": "Allow",
        "description": "Allow all access",
        "headers": null,
        "ipAddress": "Any",
        "name": "Allow all",
        "priority": 1,
        "subnetMask": null,
        "subnetTrafficTag": null,
        "tag": null,
        "vnetSubnetResourceId": null,
        "vnetTrafficTag": null
      }
    ],
    "scmIpSecurityRestrictionsUseMain": null,
    "scmMinTlsVersion": null,
    "scmType": null,
    "sitePort": null,
    "storageType": null,
    "supportedTlsCipherSuites": null,
    "tracingOptions": null,
    "use32BitWorkerProcess": null,
    "virtualApplications": null,
    "vnetName": null,
    "vnetPrivatePortsCount": null,
    "vnetRouteAllEnabled": null,
    "webSocketsEnabled": null,
    "websiteTimeZone": null,
    "winAuthAdminState": null,
    "winAuthTenantState": null,
    "windowsFxVersion": null,
    "xManagedServiceIdentityId": null
  },
  "slotSwapStatus": null,
  "state": "Running",
  "storageAccountRequired": false,
  "suspendedTill": null,
  "tags": null,
  "targetSwapSlot": null,
  "trafficManagerHostNames": null,
  "type": "Microsoft.Web/sites",
  "usageState": "Normal",
  "virtualNetworkSubnetId": null
}
```

7. Check existing resources in resource group
```
az resource list 
    --resource-group azure-lohika-rg 
    --query "[].{kind:kind, name:name}"
```

```json
[
  {
    "kind": null,
    "name": "Failure Anomalies - AppInsights"
  },
  {
    "kind": null,
    "name": "Application Insights Smart Detection"
  },
  {
    "kind": "web",
    "name": "AppInsights"
  },
  {
    "kind": "StorageV2",
    "name": "ozstoaacclohika"
  },
  {
    "kind": "app",
    "name": "FunctionPlan"
  },
  {
    "kind": "functionapp",
    "name": "fn-olehzazure"
  }
]
```

8. Delete resource group
```
az group delete --name azure-lohika-rg
```