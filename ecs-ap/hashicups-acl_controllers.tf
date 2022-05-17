module "acl_controller" {
  for_each = { for cluster in aws_ecs_cluster.clusters : cluster.name => cluster }
  source   = "registry.terraform.io/hashicorp/consul-ecs/aws//modules/acl-controller"
  version  = "0.4.1"
  log_configuration = {
    logDriver = var.ecs_ap_globals.cloudwatch_config.log_driver
    options = {
      awslogs-group         = aws_cloudwatch_log_group.acl_controllers[each.value.name].name
      awslogs-region        = var.region
      awslogs-stream-prefix = "${each.value.name}-${local.acl_prefixes.logs}"
      awslogs-create-group  = var.ecs_ap_globals.cloudwatch_config.create_groups
    }
  }
  subnets                           = module.vpc.private_subnets
  consul_server_http_addr           = hcp_consul_cluster.example.consul_public_endpoint_url
  consul_bootstrap_token_secret_arn = aws_secretsmanager_secret.bootstrap_token.arn
  region                            = var.region
  consul_partitions_enabled         = var.ecs_ap_globals.enable_admin_partitions.enabled
  consul_partition                  = each.value.name == local.clusters.one ? local.admin_partitions.one : local.admin_partitions.two
  ecs_cluster_arn                   = each.value.arn
  name_prefix                       = "${local.acl_base}-${each.value.name}"
}
