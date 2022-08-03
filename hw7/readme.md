### Create VM with password from azure key vault

1. Initially I created key value with az cli, then I created secret for admin password in key vault <br />
Script with commands here
<br />
https://github.com/ozheleztsov/oz-azure-course/blob/main/hw7/create-keyvault.ps1

2. Next step creating vm <br />
I created vm.bicep module and passed user password as a secure parameter into this module <br/>
https://github.com/ozheleztsov/oz-azure-course/blob/main/hw7/vm.bicep

I main.bicep file I attached the module for vm and reference key vault as existing resource <br />
To get secret value I use **keyVault.getSecret('vmAdminPassword')**  function to set secure parameter for module <br />
https://github.com/ozheleztsov/oz-azure-course/blob/main/hw7/main.bicep

To deploy main.bicep
```
az deployment group create --name VmDeployment --resource-group ozazurecourserg --template-file main.bicep --parameters parameters.json
```

Result of deploying main.bicep file
![vm](https://github.com/ozheleztsov/oz-azure-course/blob/main/hw7/result.png)