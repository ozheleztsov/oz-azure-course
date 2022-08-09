param serv1Name string = 'Serv1'
param serv2Name string = 'Serv2'
param vnetName string = 'ozhw8VNet'
param networkInterfaceServ1Name string = 'serv1342'
param networkInterfaceServ2Name string = 'serv2281'
param publicIpAddressServ1Name string = 'Serv1-ip'
param publicIpAddressServ2Name string = 'Serv2-ip'
param nsgServ1Name string = 'Serv1-nsg'
param nsgServ2Name string = 'Serv2-nsg'
param availabilitySetName string = 'ozhw8availabset'
param applicationGatewayName string = 'ozhw8AppGateway'
param publicIpAddressName string = 'ozhw8AGPublicIPAddress'
param serv1DiskName string = 'Serv1_1237676'
param serv2DiskName string = 'Serv2_5634346'
param location string = 'eastus'
param adminName string = 'oleh'

//setup password here
@secure()
param adminPassword string = '********'


var applicationGatewayId = resourceId(resourceGroup().name, 'Microsoft.Network/applicationGateways', applicationGatewayName)



resource nsgServ1 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: nsgServ1Name
  location: location
  properties: {
    securityRules: []
  }
}

resource nsgServ2 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: nsgServ2Name
  location: location
  properties: {
    securityRules: []
  }
}

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIpAddressName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.127.134.56'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource publicIpAddressServ1 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIpAddressServ1Name
  location: location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '40.76.38.76'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource publicIpAddressServ2 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIpAddressServ2Name
  location: location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '40.76.45.217'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'AGSubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'BackendSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource serv1iis 'Microsoft.Compute/virtualMachines/extensions@2022-03-01' = {
  name: '${serv1Name}/IIS'
  location: location
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.4'
    settings: {
      commandToExecute: 'powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path "C:\\inetpub\\wwwroot\\Default.htm" -Value $($env:computername)'
    }
    protectedSettings: {
    }
  }
  dependsOn: [
    vmserv1
  ]
}

resource serv2iis 'Microsoft.Compute/virtualMachines/extensions@2022-03-01' = {
  name: '${serv2Name}/IIS'
  location: location
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.4'
    settings: {
      commandToExecute: 'powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path "C:\\inetpub\\wwwroot\\Default.htm" -Value $($env:computername)'
    }
    protectedSettings: {
    }
  }
  dependsOn: [
    vmserv2
  ]
}

resource agsubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: vnet
  name: 'AGSubnet'
  properties: {
    addressPrefix: '10.0.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource backendsubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: vnet
  name: 'BackendSubnet'
  properties: {
    addressPrefix: '10.0.1.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource availabilityset 'Microsoft.Compute/availabilitySets@2022-03-01' = {
  name: availabilitySetName
  location: location
  sku: {
    name: 'Aligned'
  }
  properties: {
    platformUpdateDomainCount: 5
    platformFaultDomainCount: 2
    virtualMachines: [
      {
        id: vmserv1.id
      }
      {
        id: vmserv2.id
      }
    ]
  }
}

resource vmserv1 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: serv1Name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2016-datacenter-gensecond'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: serv1DiskName
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          //id: serv1DiskId
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: []
    }
    osProfile: {
      computerName: serv1Name
      adminUsername: adminName
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
        }
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceServ1.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
  }
}

resource vmserv2 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: serv2Name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2016-datacenter-gensecond'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: serv2DiskName
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          //id: serv2DiskId
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: []
    }
    osProfile: {
      computerName: serv2Name
      adminUsername: adminName
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
        }
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaceServ2.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
  }
}




resource networkInterfaceServ1 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: networkInterfaceServ1Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '10.0.1.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpAddressServ1.id
          }
          subnet: {
            id: backendsubnet.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          applicationGatewayBackendAddressPools: [
            {
              id: '${applicationGatewayId}/backendAddressPools/ozhw8BackendPool'
            }
          ]
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    networkSecurityGroup: {
      id: nsgServ1.id
    }
  }
}

resource networkInterfaceServ2 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: networkInterfaceServ2Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '10.0.1.5'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpAddressServ2.id
          }
          subnet: {
            id: backendsubnet.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          applicationGatewayBackendAddressPools: [
            {
              id: '${applicationGateway.id}/backendAddressPools/ozhw8BackendPool'
            }
          ]
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    networkSecurityGroup: {
      id: nsgServ2.id
    }
  }
}

resource applicationGateway 'Microsoft.Network/applicationGateways@2020-11-01' = {
  name: applicationGatewayName
  location: location
  properties: {
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: agsubnet.id
          }
        }
      }
    ]
    sslCertificates: []
    trustedRootCertificates: []
    trustedClientCertificates: []
    sslProfiles: []
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpAddress.id
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port_80'
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'ozhw8BackendPool'
        properties: {
          backendAddresses: []
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'ozhw8HTTPSetting'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          pickHostNameFromBackendAddress: false
          requestTimeout: 20
        }
      }
    ]
    httpListeners: [
      {
        name: 'ozhw8Listener'
        properties: {
          frontendIPConfiguration: {
            id: '${applicationGatewayId}/frontendIPConfigurations/appGwPublicFrontendIp'
          }
          frontendPort: {
            id: '${applicationGatewayId}/frontendPorts/port_80'
          }
          protocol: 'Http'
          hostNames: []
          requireServerNameIndication: false
        }
      }
    ]
    urlPathMaps: []
    requestRoutingRules: [
      {
        name: 'ozhw8RoutingRule'

        properties: {
          ruleType: 'Basic'
          priority: 100
          httpListener: {
            id: '${applicationGatewayId}/httpListeners/ozhw8Listener'
          }
          backendAddressPool: {
            id: '${applicationGatewayId}/backendAddressPools/ozhw8BackendPool'
          }
          backendHttpSettings: {
            id: '${applicationGatewayId}/backendHttpSettingsCollection/ozhw8HTTPSetting'
          }
        }
      }
    ]
    probes: []
    rewriteRuleSets: []
    redirectConfigurations: []
    privateLinkConfigurations: []
    enableHttp2: false
    autoscaleConfiguration: {
      minCapacity: 0
      maxCapacity: 10
    }
  }
}
