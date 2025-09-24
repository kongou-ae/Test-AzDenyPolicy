targetScope = 'managementGroup'

resource policy 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'deny-expensive-gpu-vm'
  properties: {
    displayName: 'Deny Expensive GPU Virtual Machines'
    policyType: 'Custom'
    mode: 'All'
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Compute/virtualMachines'
          }
          {
            allOf: [
              {
                anyof: [
                  {
                    field: 'Microsoft.Compute/virtualMachines/sku.name'
                    like: 'Standard_ND*'
                  }
                  {
                    field: 'Microsoft.Compute/virtualMachines/sku.name'
                    like: 'Standard_NV*'
                  }
                  {
                    field: 'Microsoft.Compute/virtualMachines/sku.name'
                    like: 'Standard_NG*'
                  }
                  {
                    field: 'Microsoft.Compute/virtualMachines/sku.name'
                    like: 'Standard_NC*'
                  }
                ]
              }
              {
                not: {
                  field: 'Microsoft.Compute/virtualMachines/sku.name'
                  in: [
                    'Standard_NV4as_v4'
                    'Standard_NV4ads_V710_v5'
                    'Standard_NC4as_T4_v3'
                    'Standard_NV6ads_A10_v5'
                  ]
                }
              }
            ]
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
    description: 'This policy denies the creation of Expensive GPU Virtual Machines'
  }
}
output policyId string = policy.id
