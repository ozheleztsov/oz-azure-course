### Deploying and configuring VM to Azure

For deploying Ubuntu VM I've written bicep deployment template
Also I installed mongo db on Ubuntu via configuration script

Template can be found here

<br />

Template <br />
https://github.com/ozheleztsov/oz-azure-course/blob/main/hw4/vmdeploy.bicep

Parameters <br />
https://github.com/ozheleztsov/oz-azure-course/blob/main/hw4/vmdeploy.parameters.json

Instead of running custom script as separate command I implemented it as a part of deployment using 'extensions' resource

```
resource config 'Microsoft.Compute/virtualMachines/extensions@2019-03-01' = {
  name: 'oleh-vm/installmongo'
  location: resourceGroup().location
  dependsOn: [
    virtualMachine
  ]
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    autoUpgradeMinorVersion: true
    settings: {
      script: 'IyEvYmluL3NoCndnZXQgLXFPIC0gaHR0cHM6Ly93d3cubW9uZ29kYi5vcmcvc3RhdGljL3BncC9zZXJ2ZXItNS4wLmFzYyB8IGFwdC1rZXkgYWRkIC0KZWNobyAiZGViIFsgYXJjaD1hbWQ2NCxhcm02NCBdIGh0dHBzOi8vcmVwby5tb25nb2RiLm9yZy9hcHQvdWJ1bnR1IGJpb25pYy9tb25nb2RiLW9yZy81LjAgbXVsdGl2ZXJzZSIgfCB0ZWUgL2V0Yy9hcHQvc291cmNlcy5saXN0LmQvbW9uZ29kYi1vcmctNS4wLmxpc3QKYXB0LWdldCB1cGRhdGUKYXB0LWdldCBpbnN0YWxsIC15IG1vbmdvZGItb3JnCnN5c3RlbWN0bCBzdGFydCBtb25nb2QKc3lzdGVtY3RsIHN0YXR1cyBtb25nb2QK'
    }
  }
}

```

Script here is Base-64 encoded string from mongo installation script <br />
I used that way because I didn't want to upload script.sh to external location

https://github.com/ozheleztsov/oz-azure-course/blob/main/hw4/script.sh

```
#!/bin/sh
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list
apt-get update
apt-get install -y mongodb-org
systemctl start mongod
systemctl status mongod
```

To encode script.sh as base-64 I used such command
```
cat script.sh | base64 -w0
```

To create resource group and deploy template there is powerhsell script <br />
https://github.com/ozheleztsov/oz-azure-course/blob/main/hw4/deploy.ps1

```powershell
az group create --location eastus --resource-group testrg
az deployment group create --resource-group testrg --template-file vmdeploy.bicep --parameters vmdeploy.parameters.json
```

After deploying these commands were used to check mongo db installation:
1. Connect to VM:
```
ssh olehadmin@20.231.*.*
```
2. Check mongo service status
```
sudo systemctl status mongod
```

Screenshot of deployed resources
https://github.com/ozheleztsov/oz-azure-course/blob/main/hw4/deployed-screen.png

Screenshot that verifies that mongo db server is installed and run
![](https://github.com/ozheleztsov/oz-azure-course/blob/main/hw4/check-mongo.png)


