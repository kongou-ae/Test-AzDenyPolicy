targetScope = 'subscription'


resource denyVnetPolicy 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'deny-vnet-creation2'
  properties: {
    displayName: 'Deny creating Virtual Network2'
    description: 'This policy denies the creation of Virtual Network' 
    mode: 'All'
    policyType: 'Custom'
    policyRule: {
      if: {
        field: 'type'
        equals: 'Microsoft.Network/virtualNetworks'
      }
      then: {
        effect: 'Deny'
      }
    }
  }
}
