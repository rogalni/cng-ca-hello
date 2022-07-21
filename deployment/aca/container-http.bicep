param containerAppName string
param location string 
param environmentName string 
param containerImage string
param containerPort int
param isExternalIngress bool
param containerRegistry string = 'docker.io'
param isPrivateRegistry bool = false
param containerRegistryUsername string = ''
param registryPassword string = ''
param enableIngress bool 
param minReplicas int = 0
param maxReplicas int = 2
param cpu string = '0.25'
param memory string = '0.5Gi'
param secrets array = []
param env array = []


resource environment 'Microsoft.App/managedEnvironments@2022-03-01' existing = {
  name: environmentName
}

resource containerApp 'Microsoft.App/containerApps@2022-03-01' = {
  name: containerAppName
  location: location
  properties: {
    managedEnvironmentId: environment.id
    configuration: {
      secrets: secrets
      registries: isPrivateRegistry ? [
        {
          server: containerRegistry
          username: containerRegistryUsername
          passwordSecretRef: registryPassword
        }
      ] : null
      ingress: enableIngress ? {
        external: isExternalIngress
        targetPort: containerPort
        transport: 'auto'
      } : null
      dapr: {
        enabled: false
        appPort: containerPort
        appId: containerAppName
      }
    }
    template: {
      containers: [
        {
          image: containerImage
          name: containerAppName
          env: env
          resources: {
            cpu: cpu
            memory: memory
          }
        }
      ]
      scale: {
        minReplicas: minReplicas
        maxReplicas: maxReplicas
      }
    }
  }
}

output fqdn string = enableIngress ? containerApp.properties.configuration.ingress.fqdn : 'Ingress not enabled'
