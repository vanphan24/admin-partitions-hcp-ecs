output "outputs_sensitive" {
  value = {
    consul_bootstrap_token = hcp_consul_cluster.example.consul_root_token_secret_id
  }
  sensitive = true
}

output "outputs_not_sensitive" {
  value = {
    consul_ui_address = hcp_consul_cluster.example.consul_public_endpoint_url
    hashicups_url = "http://${aws_lb.example_client_app.dns_name}"
  }
}

output "vpc_id" {
  description = "ID of project VPC"
  value       = module.vpc.vpc_id
}

output "vpc_name" {
  description = "name of project VPC"
  value       = module.vpc.name
}

output "private_subnet" {
  description = "private subnets"
  value       = module.vpc.private_subnets
}

