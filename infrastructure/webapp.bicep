param dockerHubUser string
param dockerImage string

param dockerHubReg string = 'https://index.docker.io/v1/'
param webAppName string = uniqueString(resourceGroup().id)
param sku string = 'F1'
param linuxFxVersion string = 'DOCKER|${dockerHubUser}/${dockerImage}:latest'
param location string = resourceGroup().location

var appServicePlanName = toLower('app-${webAppName}')
var webSiteName = toLower('wapp-${webAppName}')

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
  kind: 'linux'
}

resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: webSiteName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        { name: 'DOCKER_ENABLE_CI'
          value: 'true'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: dockerHubReg
        }
      ]
      linuxFxVersion: linuxFxVersion
    }
  }
}
