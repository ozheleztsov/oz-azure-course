## Azure pricing calculator

I created simple estimate for:
 - 2 ubuntu VMs
 - 2 public ip addresses
 - Virtual network
 - Application gateway

 After exporting estimation as excel file, I got such results
 <br />
 ![estimation](https://github.com/ozheleztsov/oz-azure-course/blob/main/hw10/azure-pricing-calculator.png)

 Here is link to excel file with results
 <br />
 [ExportedEstimate.xlsx](https://github.com/ozheleztsov/oz-azure-course/blob/main/hw10/azure-pricing-calculator.png)

 <br />

 ## Service principal

 I used az to create service principal

 1. Create service principal with contributor role in resource group scope
 ```
 az ad sp create-for-rbac --name ozhw10olehsp --role Contributor --scopes /subscriptions/391264ae-2d45-4841-99e6-ef8bb8787ef7/resourceGroups/ozhw10rg
 ```

 Output:
 ```
 {
  "appId": "24c7108e-def5-4bf6-9bb1-a61890b6f59f",
  "displayName": "ozhw10olehsp",
  "password": "****",
  "tenant": "4adb5839-69b2-40ce-9377-81e8d416b7c0"
}

 ```

 2. Login to azure as service principal ( I hide password that was returned in previous step)
 ```
az login --service-principal --username "24c7108e-def5-4bf6-9bb1-a61890b6f59f" --password "****" --tenant "4adb5839-69b2-40ce-9377-81e8d416b7c0"
 ```

 Output:
 ```
 [
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "4adb5839-69b2-40ce-9377-81e8d416b7c0",
    "id": "***",
    "isDefault": true,
    "managedByTenants": [],
    "name": "Azure subscription 1",
    "state": "Enabled",
    "tenantId": "4adb5839-69b2-40ce-9377-81e8d416b7c0",
    "user": {
      "name": "****",
      "type": "servicePrincipal"
    }
  }
]
 ```

 3. SP has contributor role in resource group so it can create resources. Create storage account as service principal
 ```
 az storage account create --name ozhw10stacc --resource-group ozhw10rg --kind StorageV2 --sku Standard_LRS --location eastus
 ```

 Output:
 ```
 {
  "accessTier": "Hot",
  "allowBlobPublicAccess": true,
  "allowCrossTenantReplication": null,
  "allowSharedKeyAccess": null,
  "allowedCopyScope": null,
  "azureFilesIdentityBasedAuthentication": null,
  "blobRestoreStatus": null,
  "creationTime": "2022-08-20T11:25:28.699746+00:00",
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
        "lastEnabledTime": "2022-08-20T11:25:30.059137+00:00"
      },
      "file": {
        "enabled": true,
        "keyType": "Account",
        "lastEnabledTime": "2022-08-20T11:25:30.059137+00:00"
      },
      "queue": null,
      "table": null
    }
  },
  "extendedLocation": null,
  "failoverInProgress": null,
  "geoReplicationStats": null,
  "id": "/subscriptions/391264ae-2d45-4841-99e6-ef8bb8787ef7/resourceGroups/ozhw10rg/providers/Microsoft.Storage/storageAccounts/ozhw10stacc",
  "identity": null,
  "immutableStorageWithVersioning": null,
  "isHnsEnabled": null,
  "isLocalUserEnabled": null,
  "isSftpEnabled": null,
  "keyCreationTime": {
    "key1": "2022-08-20T11:25:28.809108+00:00",
    "key2": "2022-08-20T11:25:28.809108+00:00"
  },
  "keyPolicy": null,
  "kind": "StorageV2",
  "largeFileSharesState": null,
  "lastGeoFailoverTime": null,
  "location": "eastus",
  "minimumTlsVersion": "TLS1_0",
  "name": "ozhw10stacc",
  "networkRuleSet": {
    "bypass": "AzureServices",
    "defaultAction": "Allow",
    "ipRules": [],
    "resourceAccessRules": null,
    "virtualNetworkRules": []
  },
  "primaryEndpoints": {
    "blob": "https://ozhw10stacc.blob.core.windows.net/",
    "dfs": "https://ozhw10stacc.dfs.core.windows.net/",
    "file": "https://ozhw10stacc.file.core.windows.net/",
    "internetEndpoints": null,
    "microsoftEndpoints": null,
    "queue": "https://ozhw10stacc.queue.core.windows.net/",
    "table": "https://ozhw10stacc.table.core.windows.net/",
    "web": "https://ozhw10stacc.z13.web.core.windows.net/"
  },
  "primaryLocation": "eastus",
  "privateEndpointConnections": [],
  "provisioningState": "Succeeded",
  "publicNetworkAccess": null,
  "resourceGroup": "ozhw10rg",
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

That it