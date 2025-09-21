targetScope = 'subscription'


resource denyVnetPolicy 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'deny-vnet-creation'
  properties: {
    displayName: 'Deny creating Virtual Network'
    description: 'This policy denies the creation of Virtual Network' 
    mode: 'All'
    policyType: 'Custom'
    policyRule: {
      if: {
        field: 'type'
        equals: 'Microsoft.Network/virtualNetworks'
      }
      then: {
        effect: 'deny'
      }
    }
  }
}
