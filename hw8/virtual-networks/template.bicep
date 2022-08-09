param vnet1_name string = 'vnet1'
param vnet2_name string = 'vnet2'
param vnet3_name string = 'vnet3'
param location string = 'eastus'

var vnet1_id = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks', vnet1_name)
var vnet2_id = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks', vnet2_name)
var vnet3_id = resourceId(resourceGroup().name, 'Microsoft.Network/virtualNetworks', vnet3_name)

resource vnet1 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: vnet1_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/24'
      ]
    }
    subnets: [
      {
        name: 'subn-1-1'
        properties: {
          addressPrefix: '10.0.0.0/28'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'subn-1-2'
        properties: {
          addressPrefix: '10.0.0.32/27'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'subn-1-3'
        properties: {
          addressPrefix: '10.0.0.128/28'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: [
      {
        name: '${vnet1_name}-to-vnet2'
        properties: {
          peeringState: 'Connected'
          remoteVirtualNetwork: {
            id: vnet2_id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: false
          useRemoteGateways: false
          remoteAddressSpace: {
            addressPrefixes: [
              '10.0.1.0/24'
            ]
          }
        }
      }
      {
        name: '${vnet1_name}-to-vnet3'
        properties: {
          peeringState: 'Connected'
          remoteVirtualNetwork: {
            id: vnet3_id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: false
          useRemoteGateways: false
          remoteAddressSpace: {
            addressPrefixes: [
              '10.0.2.0/24'
            ]
          }
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource vnet2 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: vnet2_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.1.0/24'
      ]
    }
    subnets: [
      {
        name: 'subn-2-1'
        properties: {
          addressPrefix: '10.0.1.0/25'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'subn-2-2'
        properties: {
          addressPrefix: '10.0.1.128/25'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: [
      {
        name: '${vnet2_name}-to-vnet1'
        properties: {
          peeringState: 'Connected'
          remoteVirtualNetwork: {
            id: vnet1_id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: false
          useRemoteGateways: false
          remoteAddressSpace: {
            addressPrefixes: [
              '10.0.0.0/24'
            ]
          }
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource vnet3 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: vnet3_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.2.0/24'
      ]
    }
    subnets: [
      {
        name: 'subn-3-1'
        properties: {
          addressPrefix: '10.0.2.0/29'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'subn-3-2'
        properties: {
          addressPrefix: '10.0.2.8/29'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.0.2.16/28'
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: [
      {
        name: '${vnet3_name}-to-vnet1'
        properties: {
          peeringState: 'Connected'
          remoteVirtualNetwork: {
            id: vnet1.id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: true
          allowGatewayTransit: false
          useRemoteGateways: false
          remoteAddressSpace: {
            addressPrefixes: [
              '10.0.0.0/24'
            ]
          }
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource vnet3_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${vnet3_name}/GatewaySubnet'
  properties: {
    addressPrefix: '10.0.2.16/28'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    vnet3
  ]
}

resource vnet1_subn_1_1 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${vnet1_name}/subn-1-1'
  properties: {
    addressPrefix: '10.0.0.0/28'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    vnet1
  ]
}

resource vnet1_subn_1_2 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${vnet1_name}/subn-1-2'
  properties: {
    addressPrefix: '10.0.0.32/27'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    vnet1
  ]
}

resource vnet1_subn_1_3 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${vnet1_name}/subn-1-3'
  properties: {
    addressPrefix: '10.0.0.128/28'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    vnet1
  ]
}

resource vnet2_subn_2_1 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${vnet2_name}/subn-2-1'
  properties: {
    addressPrefix: '10.0.1.0/25'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    vnet2
  ]
}

resource vnet2_subn_2_2 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${vnet2_name}/subn-2-2'
  properties: {
    addressPrefix: '10.0.1.128/25'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    vnet2
  ]
}

resource vnet3_subn_3_1 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${vnet3_name}/subn-3-1'
  properties: {
    addressPrefix: '10.0.2.0/29'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    vnet3
  ]
}

resource vnet3_subn_3_2 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${vnet3_name}/subn-3-2'
  properties: {
    addressPrefix: '10.0.2.8/29'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    vnet3
  ]
}



resource vnet1_to_vnet2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  name: '${vnet1_name}/${vnet1_name}-to-vnet2'
  properties: {
    peeringState: 'Connected'
    remoteVirtualNetwork: {
      id: vnet2_id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.0.1.0/24'
      ]
    }
  }
  dependsOn: [
    vnet1

  ]
}

resource vnet1_to_vnet3 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  name: '${vnet1_name}/${vnet1_name}-to-vnet3'
  properties: {
    peeringState: 'Connected'
    remoteVirtualNetwork: {
      id: vnet3_id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.0.2.0/24'
      ]
    }
  }
  dependsOn: [
    vnet1
  ]
}

resource vnet2_name_to_vnet1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  name: '${vnet2_name}/${vnet2_name}-to-vnet1'
  properties: {
    peeringState: 'Connected'
    remoteVirtualNetwork: {
      id: vnet1_id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.0.0.0/24'
      ]
    }
  }
  dependsOn: [
    vnet2
  ]
}

resource vnet3_to_vnet1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2020-11-01' = {
  name: '${vnet3_name}/${vnet3_name}-to-vnet1'
  properties: {
    peeringState: 'Connected'
    remoteVirtualNetwork: {
      id: vnet1_id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteAddressSpace: {
      addressPrefixes: [
        '10.0.0.0/24'
      ]
    }
  }
  dependsOn: [
    vnet3
  ]
}
