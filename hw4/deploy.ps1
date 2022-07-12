az group create --location eastus --resource-group testrg
az deployment group create --resource-group testrg --template-file vmdeploy.bicep --parameters vmdeploy.parameters.json