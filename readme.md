This demo will deploy a new HCP Consul server along with Consul clients on ECS on different admin partitions. It will also deploy Hashicups app once Consul is deployed.
It will use TF, which will create and deploy all necessary resources, including VCPs, subnets, sec groups, etc.
This demo is based on this Learn Guide: https://learn.hashicorp.com/tutorials/consul/amazon-ecs-admin-partitions?in=consul/cloud-integrations

After Consul is depoyed on ECS, we will also deploy Consul clients on EKS onto a different partition. For the EKS deployment, we will use:
- eckctl to deploy a new EKS cluster
- helm to deploy Consul clients nodes
- kubectl to deploy an example app

# PRE-REQ 
HCP account and Service Principle crentials.



# Deploy Consul on ECS with Admin Partitions and HashiCups

```
export HCP_CLIENT_ID=YOUR_HCP_CLIENT_ID_GOES_HERE
export HCP_CLIENT_SECRET=YOUR_HCP_CLIENT_SECRET_GOES_HERE
```



```deploy-ecs-hcp-ap/terraform init```

```deploy-ecs-hcp-ap/terraform plan```

```deploy-ecs-hcp-ap/terraform apply -auto-approve```

Retreive VPC, subnet, SG values as environmental variables

```
export vpc_id=$(terraform output -json vpc_id)
export subnet1=$(terraform output -json private_subnet | jq '.[0]')
export subnet2=$(terraform output -json private_subnet | jq '.[1]')
export subnet3=$(terraform output -json private_subnet | jq '.[2]')
```


# Deploy Consul Client on EKS

1) Deploy a new EKS Cluster. You can 

Use eksctl 
