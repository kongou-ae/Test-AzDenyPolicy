targetScope = 'resourceGroup'

// Simple Bicep template that creates a VM with size Standard_nv8as_v4
// Values previously declared as top-level variables have been inlined into resource definitions as requested.

param location string = resourceGroup().location

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: 'vm-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'vm-subnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'standard-nv8-vm-nic'
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
  name: 'standard-nv8-vm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_nv8as_v4'
    }
    osProfile: {
      computerName: 'standard-nv8-vm'
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
