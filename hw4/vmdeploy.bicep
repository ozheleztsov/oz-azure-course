param location string
param adminUsername string

@secure()
param adminPassword string

param virtualNetworkName string = 'temprg-vnet'
param networkSecurityGroupName string = 'oleh-vm-nsg'
param publicIpAddessName string = 'oleh-vm-ip'


var networkSecurityGroupId = resourceId(resourceGroup().name, 'Microsoft.Network/networkSecurityGroups', networkSecurityGroupName)
var virtualNetworkId = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks', virtualNetworkName)
var subnetId= '${virtualNetworkId}/subnets/default'

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2020-08-01' = {
  name: publicIpAddessName
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
  sku: {
    name: 'Basic'
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2019-02-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          direction: 'Inbound'
          protocol: 'Tcp'
          access: 'Allow'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
          priority: 300
        }
      }
    ] 
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: 'oleh-vm334'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId(resourceGroup().name, 'Microsoft.Network/publicIpAddresses', publicIpAddessName)
            properties: {
              deleteOption: 'Detach'
            }
          }
        }
      } 
    ] 
    networkSecurityGroup: {
      id: networkSecurityGroupId
    }
  }
  dependsOn: [
    networkSecurityGroup
    virtualNetwork
    publicIpAddress
  ]
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: 'oleh-vm'
  location: location
  properties: {
   hardwareProfile: {
    vmSize:'Standard_B1s'
   } 
   storageProfile: {
    osDisk: {
      createOption: 'FromImage'
      managedDisk: {
        storageAccountType: 'Premium_LRS'
      }
      diskSizeGB: 30
      deleteOption: 'Delete'
    }
    imageReference: {
      publisher: 'Canonical'
      offer: 'UbuntuServer'
      sku: '18_04-lts-gen2'
      version: 'latest'
    }
   }
   networkProfile: {
    networkInterfaces: [
      {
        id: networkInterface.id
        properties: {
          deleteOption: 'Detach'
        }
      }
    ]
   }

   osProfile: {
    computerName: 'oleh-vm'
    adminUsername: adminUsername
    adminPassword: adminPassword
    linuxConfiguration: {
      patchSettings: {
        patchMode: 'ImageDefault'
      }
    }
   }

   diagnosticsProfile: {
    bootDiagnostics: {
      enabled: true
    }
   }
  }
}


resource config 'Microsoft.Compute/virtualMachines/extensions@2019-03-01' = {
  name: 'oleh-vm/installmongo'
  location: resourceGroup().location
  dependsOn: [
    virtualMachine
  ]
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    autoUpgradeMinorVersion: true
    settings: {
      script: 'IyEvYmluL3NoCndnZXQgLXFPIC0gaHR0cHM6Ly93d3cubW9uZ29kYi5vcmcvc3RhdGljL3BncC9zZXJ2ZXItNS4wLmFzYyB8IGFwdC1rZXkgYWRkIC0KZWNobyAiZGViIFsgYXJjaD1hbWQ2NCxhcm02NCBdIGh0dHBzOi8vcmVwby5tb25nb2RiLm9yZy9hcHQvdWJ1bnR1IGJpb25pYy9tb25nb2RiLW9yZy81LjAgbXVsdGl2ZXJzZSIgfCB0ZWUgL2V0Yy9hcHQvc291cmNlcy5saXN0LmQvbW9uZ29kYi1vcmctNS4wLmxpc3QKYXB0LWdldCB1cGRhdGUKYXB0LWdldCBpbnN0YWxsIC15IG1vbmdvZGItb3JnCnN5c3RlbWN0bCBzdGFydCBtb25nb2QKc3lzdGVtY3RsIHN0YXR1cyBtb25nb2QK'
    }
  }
}


output adminUsername string = adminUsername
