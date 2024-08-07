targetScope='subscription'

param resourceGroupUKSParam object
param tagsParam object = {}
param vnetParam object
param keyVaultParam object
param vmParam object

var serviceName = 'selfhostedagent'

module resourceGroupUKS 'modules/resource-group.bicep' = {
  name: '${serviceName}-resourceGroup'
  params: {
    resourceGroup: resourceGroupUKSParam
    tags: tagsParam
  }
}

module virtualNetwork 'modules/virtual-network.bicep' = {
  name: '${serviceName}-virtualNetwork'
  scope: resourceGroup(resourceGroupUKSParam.name)
  params: {
    vnet: vnetParam
    tags: tagsParam
    location: resourceGroupUKSParam.location
  }
  dependsOn: [
    resourceGroupUKS
  ]
}

module keyVault 'modules/key-vault.bicep' = {
  name: '${serviceName}-keyVault'
  scope: resourceGroup(resourceGroupUKSParam.name)
  params: {
    keyVault: keyVaultParam
    tags: tagsParam
    location: resourceGroupUKSParam.location
  }
  dependsOn: [
    resourceGroupUKS
  ]
}

module virtualMachine 'modules/virtual-machine.bicep' = {
  name: '${serviceName}-virtualMachine'
  scope: resourceGroup(resourceGroupUKSParam.name)
  params: {
    tags: tagsParam
    location: resourceGroupUKSParam.location
    vm: vmParam
    subnetId: virtualNetwork.outputs.subnetId
  }
  dependsOn: [
    virtualNetwork
  ]
}

output keyVaultId string = keyVault.outputs.keyVaultId
output vnetdefaultsubnetId string = virtualNetwork.outputs.subnetId
