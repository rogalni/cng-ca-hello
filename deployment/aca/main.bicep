param location string = resourceGroup().location
param environmentName string = 'env-${uniqueString(resourceGroup().id)}'
var goServiceAppName = 'cng-ca-hello'

// Container Apps Environment 
module environment 'environment.bicep' = {
  name: '${deployment().name}--environment'
  params: {
    environmentName: environmentName
    location: location
    appInsightsName: '${environmentName}-ai'
    logAnalyticsWorkspaceName: '${environmentName}-la'
  }
}

// Go App
module goService 'container-http.bicep' = {
  name: '${deployment().name}--${goServiceAppName}'
  dependsOn: [
    environment
  ]
  params: {
    enableIngress: true
    isExternalIngress: true
    location: location
    environmentName: environmentName
    containerAppName: goServiceAppName
    containerImage: 'roglan/cng-ca-hello'
    containerPort: 8080
    minReplicas: 0
    maxReplicas: 3
  }
}

output goFqdn string = goService.outputs.fqdn
