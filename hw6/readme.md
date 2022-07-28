### 1. Creating sql server database using terraform
<br />
I wrote terraform deployment script here
<br />
https://github.com/ozheleztsov/oz-azure-course/blob/main/hw6/sql-deploy-terraform/main.tf

Screenshot of result resources after applying this script. There are sql server and sql database in it
<br/ >
![sql server](https://github.com/ozheleztsov/oz-azure-course/blob/main/hw6/sql-deploy-terraform/screen.PNG)

### 2. Creating azure table using arm resource
<br />
I wrote bicep script that creates storage account, table service in it and table in table service. Bicep deployment script here
<br />
https://github.com/ozheleztsov/oz-azure-course/blob/main/hw6/azure-table-bicep/azuredeploy.bicep

Screenshot of created table here
<br />
![azure table](https://github.com/ozheleztsov/oz-azure-course/blob/main/hw6/azure-table-bicep/deployment-table-screen.PNG)