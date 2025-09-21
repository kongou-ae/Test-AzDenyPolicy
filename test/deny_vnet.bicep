resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: 'vnet'
  location: 'japaneast'
  properties: {
    addressSpace: {
      addressPrefixes: ['192.168.0.0/24']
    }
    subnets: [
      {
        name: 'subnet1'
        properties: {
          addressPrefix: '192.168.0.0/25'
        }
      }
    ]
  }
}
