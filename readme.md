This demo will deploy a new HCP Consul server along with Consul clients on ECS on different admin partitions. It will also deploy Hashicups app once Consul is deployed.
It will use TF, which will create and deploy all necessary resources, including VCPs, subnets, sec groups, etc.
This demo is based on this Learn Guide: https://learn.hashicorp.com/tutorials/consul/amazon-ecs-admin-partitions?in=consul/cloud-integrations

After Consul is depoyed on ECS, we will also deploy Consul clients on EKS onto a different partition. For the EKS deployment, we will use:
- eckctl to deploy a new EKS cluster
- helm to deploy Consul clients nodes
- kubectl to deploy an example app

# PRE-REQ 
HCP account and Service Principle crentials.



export HCP_CLIENT_ID=YOUR_HCP_CLIENT_ID_GOES_HERE
export HCP_CLIENT_SECRET=YOUR_HCP_CLIENT_SECRET_GOES_HERE
