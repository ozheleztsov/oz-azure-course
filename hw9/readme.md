## Azure registry and Azure container instance

For deploying I created simple asp.net core application that just show text with app version on main page. <br>
To create docker image I used dockerfile [Dockerfile](https://raw.githubusercontent.com/ozheleztsov/oz-azure-course/main/hw9/Dockerfile)

Build image for version 1 from dockerfile
```
docker build -t oz/webapp:v1 -f .\OzWebApp\Dockerfile .
```

I changed version text in application and build version 2 of docker image
```
docker build -t oz/webapp:v2 -f .\OzWebApp\Dockerfile .
```

So I have 2 images in local repository **oz/webapp:v1** and  **oz/webapp:v2**

1. Create resource group
```
az group create --name ozhw9rg --location eastus
```

2. Create container registry 
```
az acr create --resource-group ozhw9rg --name ozhw9registry --sku Basic
```

Output:
```
{
  "adminUserEnabled": false,
  "anonymousPullEnabled": false,
  "creationDate": "2022-08-14T12:19:12.305924+00:00",
  "dataEndpointEnabled": false,
  "dataEndpointHostNames": [],
  "encryption": {
    "keyVaultProperties": null,
    "status": "disabled"
  },
  "id": "/subscriptions/391264ae-2d45-4841-99e6-ef8bb8787ef7/resourceGroups/ozhw9rg/providers/Microsoft.ContainerRegistry/registries/ozhw9registry",
  "identity": null,
  "location": "eastus",
  "loginServer": "ozhw9registry.azurecr.io",
  "name": "ozhw9registry",
  "networkRuleBypassOptions": "AzureServices",
  "networkRuleSet": null,
  "policies": {
    "exportPolicy": {
      "status": "enabled"
    },
    "quarantinePolicy": {
      "status": "disabled"
    },
    "retentionPolicy": {
      "days": 7,
      "lastUpdatedTime": "2022-08-14T12:19:19.519097+00:00",
      "status": "disabled"
    },
    "trustPolicy": {
      "status": "disabled",
      "type": "Notary"
    }
  },
  "privateEndpointConnections": [],
  "provisioningState": "Succeeded",
  "publicNetworkAccess": "Enabled",
  "resourceGroup": "ozhw9rg",
  "sku": {
    "name": "Basic",
    "tier": "Basic"
  },
  "status": null,
  "systemData": {
    "createdAt": "2022-08-14T12:19:12.305924+00:00",
    "createdBy": "olehzazure@gmail.com",
    "createdByType": "User",
    "lastModifiedAt": "2022-08-14T12:19:12.305924+00:00",
    "lastModifiedBy": "olehzazure@gmail.com",
    "lastModifiedByType": "User"
  },
  "tags": {},
  "type": "Microsoft.ContainerRegistry/registries",
  "zoneRedundancy": "Disabled"
}

```

There are 2 fields to remember
```
  "loginServer": "ozhw9registry.azurecr.io",
  "name": "ozhw9registry",
```

3. Login to azure container registry
```
az acr login --name ozhw9registry
```

4. Tag my images with acr login server
```
docker tag oz/webapp:v1 ozhw9registry.azurecr.io/webapp:v1
docker tag oz/webapp:v2 ozhw9registry.azurecr.io/webapp:v2
```

5. Push images to ACR
```
docker push ozhw9registry.azurecr.io/webapp:v1
docker push ozhw9registry.azurecr.io/webapp:v2
```

6. Verify that images are pushed
```
az acr repository list --name ozhw9registry --output table
```
Output:
```
Result
--------
webapp
```

Verify what tags  webapp image has
```
az acr repository show-tags --name ozhw9registry --repository webapp --output table
```
Output:
```
Result
--------
v1
v2
```

7. To be able access registry from azure container instances I created service principal as described in 
microsoft documentation
```
$ACR_NAME='ozhw9registry'
$SERVICE_PRINCIPAL_NAME='ozhw9servprincipal'
$ACR_REGISTRY_ID  = (az acr show --resource-group ozhw9rg --name $ACR_NAME --query "id" --output tsv)
$PASSWORD=(az ad sp create-for-rbac --name $SERVICE_PRINCIPAL_NAME --scopes $ACR_REGISTRY_ID --role contributor --query "password" --output tsv)
$USER_NAME=(az ad sp list --display-name $SERVICE_PRINCIPAL_NAME --query "[].appId" --output tsv)
```

8. Using service principal id and password I actually created azure container instance
```
az container create --resource-group ozhw9rg --name ozhw9webapp --image ozhw9registry.azurecr.io/webapp:v1 --cpu 1 --memory 1 --registry-login-server ozhw9registry.azurecr.io --registry-username $USER_NAME --registry-password $PASSWORD --ip-address Public --dns-name-label ozhw9lbl --ports 80
```
Output:
```
{
  "containers": [
    {
      "command": null,
      "environmentVariables": [],
      "image": "ozhw9registry.azurecr.io/webapp:v1",
      "instanceView": {
        "currentState": {
          "detailStatus": "",
          "exitCode": null,
          "finishTime": null,
          "startTime": "2022-08-14T12:59:35.552000+00:00",
          "state": "Running"
        },
        "events": [
          {
            "count": 1,
            "firstTimestamp": "2022-08-14T12:59:26+00:00",
            "lastTimestamp": "2022-08-14T12:59:26+00:00",
            "message": "pulling image \"ozhw9registry.azurecr.io/webapp@sha256:ff8d44580a94a59e410b953ca2004b1c73117a8b3d204a17427c929828daa32b\"",
            "name": "Pulling",
            "type": "Normal"
          },
          {
            "count": 1,
            "firstTimestamp": "2022-08-14T12:59:28+00:00",
            "lastTimestamp": "2022-08-14T12:59:28+00:00",
            "message": "Successfully pulled image \"ozhw9registry.azurecr.io/webapp@sha256:ff8d44580a94a59e410b953ca2004b1c73117a8b3d204a17427c929828daa32b\"",
            "name": "Pulled",
            "type": "Normal"
          },
          {
            "count": 1,
            "firstTimestamp": "2022-08-14T12:59:35+00:00",
            "lastTimestamp": "2022-08-14T12:59:35+00:00",
            "message": "Started container",
            "name": "Started",
            "type": "Normal"
          }
        ],
        "previousState": null,
        "restartCount": 0
      },
      "livenessProbe": null,
      "name": "ozhw9webapp",
      "ports": [
        {
          "port": 80,
          "protocol": "TCP"
        }
      ],
      "readinessProbe": null,
      "resources": {
        "limits": null,
        "requests": {
          "cpu": 1.0,
          "gpu": null,
          "memoryInGb": 1.0
        }
      },
      "volumeMounts": null
    }
  ],
  "diagnostics": null,
  "dnsConfig": null,
  "encryptionProperties": null,
  "id": "/subscriptions/391264ae-2d45-4841-99e6-ef8bb8787ef7/resourceGroups/ozhw9rg/providers/Microsoft.ContainerInstance/containerGroups/ozhw9webapp",
  "identity": null,
  "imageRegistryCredentials": [
    {
      "identity": null,
      "identityUrl": null,
      "password": null,
      "server": "ozhw9registry.azurecr.io",
      "username": "39669296-37e4-4aa8-a041-ed897a626e4f"
    }
  ],
  "initContainers": [],
  "instanceView": {
    "events": [],
    "state": "Running"
  },
  "ipAddress": {
    "autoGeneratedDomainNameLabelScope": "Unsecure",
    "dnsNameLabel": "ozhw9lbl",
    "fqdn": "ozhw9lbl.eastus.azurecontainer.io",
    "ip": "20.253.25.227",
    "ports": [
      {
        "port": 80,
        "protocol": "TCP"
      }
    ],
    "type": "Public"
  },
  "location": "eastus",
  "name": "ozhw9webapp",
  "osType": "Linux",
  "provisioningState": "Succeeded",
  "resourceGroup": "ozhw9rg",
  "restartPolicy": "Always",
  "sku": "Standard",
  "subnetIds": null,
  "tags": {},
  "type": "Microsoft.ContainerInstance/containerGroups",
  "volumes": null,
  "zones": null
}
```

9. Get url of running container
```
az container show --resource-group ozhw9rg --name ozhw9webapp --query ipAddress.fqdn
```

Output:
```
"ozhw9lbl.eastus.azurecontainer.io"
```

10. Make web request to running container
```
(Invoke-WebRequest http://ozhw9lbl.eastus.azurecontainer.io/).rawcontent
```

Output (truncated):
```
<div b-w0g86yyffj class="container">
    <main b-w0g86yyffj role="main" class="pb-3">

<div class="text-center">
    <p>Web app version 1</p>
</div>
    </main>
</div>
```

## Deployment to Azure Kubernetes Service
For testing AKS I used container images pushed to registry in previous task
I created simple deployment file <br />
[deployment.yaml](https://raw.githubusercontent.com/ozheleztsov/oz-azure-course/main/hw9/deployment.yaml)

1. Create AKS cluster
```
az aks create --resource-group ozhw9rg --name ozhw9cluster --node-count 1 --generate-ssh-keys --attach-acr ozhw9registry
```

2. Get credentials for kubernetes for local kubectl
```
az aks get-credentials --resource-group ozhw9rg --name ozhw9cluster
```

3. Check the cluster nodes (1 created only 1 node)
```
kubectl get nodes
```

Output:
```
NAME                                STATUS   ROLES   AGE    VERSION
aks-nodepool1-11448230-vmss000000   Ready    agent   3m3s   v1.22.11
```

4. Deploy my service
```
kubectl apply -f deployment.yaml
```

Check the service
```
get service oz-hw9 --watch
```
Output:
```
NAME     TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)        AGE
oz-hw9   LoadBalancer   10.0.142.93   52.226.206.101   80:31205/TCP   61s
```

Check the pods
```
kubectl get pods
```
Output:
```
NAME                      READY   STATUS    RESTARTS   AGE
oz-hw9-6bd755d49c-qwg6h   1/1     Running   0          82s
```

Make request to service to be sure that everything is working as expected
```
(Invoke-WebRequest 52.226.206.101).rawcontent
```
Output (truncated):
```
<div b-w0g86yyffj class="container">
    <main b-w0g86yyffj role="main" class="pb-3">

<div class="text-center">
    <p>Web app version 1</p>
</div>
    </main>
</div>
```

5. Update container to version 2
```
kubectl set image deployment/oz-hw9 webapp=ozhw9registry.azurecr.io/webapp:v2
```
Output:
```
Warning: spec.template.spec.nodeSelector[beta.kubernetes.io/os]: deprecated since v1.14; use "kubernetes.io/os" instead
deployment.apps/oz-hw9 image updated
```

Make request to verify that version 2 is running
```
(Invoke-WebRequest 52.226.206.101).rawcontent
```
Output:
```
<div b-w0g86yyffj class="container">
    <main b-w0g86yyffj role="main" class="pb-3">

<div class="text-center">
    <p>Web app version 2</p>
</div>
    </main>
</div>
```

6. View deployment history
```
kubectl rollout history deployment/oz-hw9
```
Output:
```
deployment.apps/oz-hw9
REVISION  CHANGE-CAUSE
3         <none>
4         <none>
```

7. Make rollback to previous version
```
kubectl rollout undo deployment/oz-hw9
```

Make request to service to check that version 1 is running again
```
(Invoke-WebRequest 52.226.206.101).rawcontent
```
Output:
```
<div b-w0g86yyffj class="container">
    <main b-w0g86yyffj role="main" class="pb-3">

<div class="text-center">
    <p>Web app version 1</p>
</div>
    </main>
</div>
```

Version 1 of my application in browser: <br/>
[v1](https://github.com/ozheleztsov/oz-azure-course/blob/main/hw9/v1.png)

Version 2 of my application in browser: <br/>
[v2](https://github.com/ozheleztsov/oz-azure-course/blob/main/hw9/v2.png)


Screen of resource group after completing the tasks <br />
[rg](https://github.com/ozheleztsov/oz-azure-course/blob/main/hw9/resource-group-view.png)

Screen of Azure Registry with my image uploaded <br />
[reg](https://github.com/ozheleztsov/oz-azure-course/blob/main/hw9/registry.png)

Screen of running Container instance <br />
[ci](https://github.com/ozheleztsov/oz-azure-course/blob/main/hw9/container-instance.png)

Screen of AKS workfloads page <br />
[workloads](https://github.com/ozheleztsov/oz-azure-course/blob/main/hw9/cluster-workloads.png)