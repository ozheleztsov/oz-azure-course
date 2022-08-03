az group create --location eastus --name ozazurecourserg
az keyvault create --location eastus --name ozazurecoursekv --resource-group ozazurecourserg --enabled-for-deployment true --enabled-for-template-deployment true
az keyvault secret set --name vmAdminPassword --vault-name ozazurecoursekv --value '**********'