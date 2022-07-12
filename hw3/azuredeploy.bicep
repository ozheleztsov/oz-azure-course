
param location string = resourceGroup().location

param appNameSuffix string = uniqueString(resourceGroup().id)

param storageSku string = 'Standard_LRS'

var functionAppName = 'fn-${appNameSuffix}'
var appServicePlanName = 'FunctionPlan'
var appInsightsName = 'AppInsights'
var storageAccountName = 'fnstor${replace(appNameSuffix, '-', '')}'
var functionNameComputed = 'MyHttpTriggeredFunction'
var functionRuntime = 'dotnet'


resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageSku
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appServicePlanName
  location: location
  kind: 'functionapp'
  sku: {
    name: 'Y1'
  }
  properties: {
  }
}

resource functionApp 'Microsoft.Web/sites@2020-12-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, '2021-04-01').keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, '2021-04-01').keys[0].value}'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: 'InstrumentationKey=${appInsights.properties.InstrumentationKey}'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: functionRuntime
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
      ]
    }
    httpsOnly: true
  }
}

resource functionComputed 'Microsoft.Web/sites/functions@2020-12-01' = {
  parent: functionApp
  name: functionNameComputed
  properties: {
    config: {
      disabled: false
      bindings: [
        {
          name: 'req'
          type: 'httpTrigger'
          direction: 'in'
          authLevel: 'anonymous'
          methods: [
            'get'
          ]
        }
        {
          name: '$return'
          type: 'http'
          direction: 'out'
        }
      ]
    }
    files: {
      'run.csx': '#r "Newtonsoft.Json"\n\nusing System.Net;\nusing Microsoft.AspNetCore.Mvc;\nusing Microsoft.Extensions.Primitives;\nusing Newtonsoft.Json;\n\npublic static async Task<IActionResult> Run(HttpRequest req, ILogger log)\n{\n      log.LogInformation("C# HTTP trigger function processed a request.");\n\n    string name = req.Query["name"];\n\n    string requestBody = await new StreamReader(req.Body).ReadToEndAsync();\n    dynamic data = JsonConvert.DeserializeObject(requestBody);\n    name = name ?? data?.name;\n\n    string responseMessage = string.IsNullOrEmpty(name)\n        ? "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."\n                : $"Hello, {name}. This HTTP triggered function executed successfully.";\n\n            return new OkObjectResult(responseMessage);\n}'
    }
  }
}

output functionAppHostName string = functionApp.properties.defaultHostName
output functionName string = functionNameComputed
