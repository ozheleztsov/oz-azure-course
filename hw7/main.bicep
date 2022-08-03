param location string
param virtualMachineName string
param adminUsername string
param keyVaultName string
param resourceGroupName string
param subscriptionId string

resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  name: keyVaultName
  scope: resourceGroup(subscriptionId, resourceGroupName)
}

module vm 'vm.bicep' = {
  name: 'deployVm'
  params: {
    adminPassword: keyVault.getSecret('vmAdminPassword') 
    adminUsername: adminUsername
    location: location
    virtualMachineName: virtualMachineName
  }
}
