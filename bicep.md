### Creating function app with bicep template file

1. Create resource group
```
az group create --name azure-lohika-rg --location eastus
```

Bicep template file that I am using
[Bicep file](https://github.com/ozheleztsov/oz-azure-course/blob/main/azuredeploy.bicep)

2. Deploy recources 
```
az deployment group create 
    --resource-group azure-lohika-rg 
    --template-file azuredeploy.bicep 
    --parameters appNameSuffix=olehzapp
```

3. Check resources created
```
az resource list --resource-group azure-lohika-rg --query "[].{kind:kind, name:name}"
```

4. Call function from deployed app
```
curl https://fn-olehzapp.azurewebsites.net/api/MyHttpTriggeredFunction?name=oleh
```

```
Hello, oleh. This HTTP triggered function executed successfully.
```

5. Delete resource group
```
```
az group delete --name azure-lohika-rg
```
```