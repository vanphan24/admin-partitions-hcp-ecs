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




# Deploy Consul Client on EKS

In order to deploy a new EKS Cluster. You can 

Use eksctl to deploy a new eks cluster. We will need to edit the yaml file to reflect the existing environment created by TF.

Retreive VPC, subnet, SG values as environmental variables

```
export vpc_id=$(terraform output -json vpc_id)
export subnet_id1=$(terraform output -json private_subnet | jq '.[0]')
export subnet_id2=$(terraform output -json private_subnet | jq '.[1]')
export subnet_id3=$(terraform output -json private_subnet | jq '.[2]')
```

Create eksctl file
```
cat <<EOF > create-eks-USeast-1.yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: eksctl-USeast1-client-adminpart1
  region: us-east-1

vpc:
  id: "${vpc_id}"
  sharedNodeSecurityGroup: "sg-0474eb4d1be0062e4"

  subnets:
    public:
      us-east-1a:
        id: "${subnet_id1}"
      us-east-1b:
        id: "${subnet_id2}"
      us-east-1c:
        id: "${subnet_id3}"

iam:
  serviceRoleARN: "arn:aws:iam::711129375688:role/eks-cluster-role-van"

managedNodeGroups:
  - name: "nodegroup-test"
    amiFamily: AmazonLinux2
    instanceType: t3.medium
    volumeSize: 20
    subnets:
      - ${subnet_id1}
      - ${subnet_id2}
      - ${subnet_id3}

    desiredCapacity: 3
    minSize: 3
    maxSize: 3
    iam:
      instanceRoleARN: "arn:aws:iam::711129375688:role/eks-worker-node-paris-van"
    ssh:
      allow: true
      publicKeyName: "van-ssh-keypair-NVirginia"
      enableSsm: true
      #Node role needs to have "AmazonSSMManagedInstanceCore" in order to SSM into ec2 instance

    securityGroups:
      attachIDs:
        - sg-0474eb4d1be0062e4
EOF
