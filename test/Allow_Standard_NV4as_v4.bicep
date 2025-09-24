targetScope = 'resourceGroup'

// Simple Bicep template that creates a VM with size Standard_NV4as_v4
// Values previously declared as top-level variables have been inlined into resource definitions as requested.

param location string = resourceGroup().location

resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'standard-nv4-vm-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'vm-vnet', 'vm-subnet')
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2022-08-01' = {
  name: 'standard-nv4-vm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_NV4as_v4'
    }
    osProfile: {
      computerName: 'standard-nv4-vm'
      #disable-next-line adminusername-should-not-be-literal
      adminUsername: 'azureuser'
      // NOTE: This password is hard-coded for demonstration only. Replace before production.
      adminPassword: 'P@ssw0rd12345!'
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
        diskSizeGB: 30
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
          properties: {
            primary: true
          }
        }
      ]
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
  tags: {
    createdBy: 'bicep-template'
  }
}

output vmId string = vm.id
