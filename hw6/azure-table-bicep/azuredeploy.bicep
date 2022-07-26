param storage_account_name string = 'ozhw6stacc'
param location string = 'westeurope'

var tablename = 'testtable'

resource storage_account 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storage_account_name
  location: location
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
  }
}

resource blob_service 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01' = {
  parent: storage_account
  name: 'default'
}

resource file_service 'Microsoft.Storage/storageAccounts/fileServices@2021-09-01' = {
  parent: storage_account
  name: 'default'
}

resource queue_service 'Microsoft.Storage/storageAccounts/queueServices@2021-09-01' = {
  parent: storage_account
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource table_service 'Microsoft.Storage/storageAccounts/tableServices@2021-09-01' = {
  parent: storage_account
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource testtable 'Microsoft.Storage/storageAccounts/tableServices/tables@2021-09-01' = {
  parent: table_service
  name: tablename
  properties: {
  }
  dependsOn: [
    storage_account
  ]
}
