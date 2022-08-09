### 1. 2 virtual machines in availability set + application gateway
<br />

First bicep template
<br />
https://github.com/ozheleztsov/oz-azure-course/blob/main/hw8/appgateway/template.bicep

<br />

It defines 2 virtual machines and availability set before them
<br />
I defined virtual network with 2 subnets - first for virtual machines (backend subnet) and second for application gateway (AGSubnet)
<br />
Visualization of resources in Azure Portal looks like
<br />
![appgateway](https://github.com/ozheleztsov/oz-azure-course/blob/main/hw8/appgateway/resource-visualizer.png)

Also template defines extensions resources for virtual machines that install IIS-server on every machine.
After deployment I had two virtual machines with IIS installed + Application gateway on front side
Screenshot with requests to gateway's public ip address demonstrates that requests come to different virtual machine every time
<br />
![requests](https://github.com/ozheleztsov/oz-azure-course/blob/main/hw8/appgateway/requests.png)

### 2. 3 peered virtual networks
<br />

In the next bicep template I defined 3 virtual networks vnet1, vnet2, vnet3. Each of them has address space 3 for 256 ip addresses maximum.
<br />
I defined subnets with CIDR block close to task requirements. It is not always possible to stick to exact values because Azure reservers 5 addresses, but I tried to define subnets as close to requiremens as possible

Also I defined peering between vnet1 and vnet2, vnet1  and vnet3
<br />
Bicep template here
<br />
https://github.com/ozheleztsov/oz-azure-course/blob/main/hw8/virtual-networks/template.bicep

<br />
Screenshot of subnets for vnet1 as example
<br />
![vnet1](https://github.com/ozheleztsov/oz-azure-course/blob/main/hw8/virtual-networks/vnet1.png)
<br />
Screenshot of peerings that were created in vnet1
<br />
![peering](https://github.com/ozheleztsov/oz-azure-course/blob/main/hw8/virtual-networks/peering.png)

Both templates can be deployed with commands
<br />
```
az group create --location eastus --name ozhw8rg
az deployment group create --resource-group ozhw8rg --template-file template.bicep
```

