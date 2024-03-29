resource "aws_security_group" "security_group" {
  count = var.enable_security_group && length(var.sg_ids) < 1 ? 1 : 0

  name        = format("%s-sg", var.name)
  vpc_id      = var.vpc_id
  description = var.sg_description
  tags        = var.tags
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "egress" {
  count = (var.enable_security_group == true && length(var.sg_ids) < 1 && var.is_external == false && var.egress_rule == true) ? 1 : 0

  description       = var.sg_egress_description
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.security_group[*].id)
}

resource "aws_security_group_rule" "egress_ipv6" {
  count = (var.enable_security_group == true && length(var.sg_ids) < 1 && var.is_external == false) && var.egress_rule == true ? 1 : 0

  description       = var.sg_egress_ipv6_description
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = join("", aws_security_group.security_group[*].id)
}
resource "aws_security_group_rule" "ingress" {
  count = length(var.allowed_ip) > 0 == true && length(var.sg_ids) < 1 ? length(compact(var.allowed_ports)) : 0

  description       = var.sg_ingress_description
  type              = "ingress"
  from_port         = element(var.allowed_ports, count.index)
  to_port           = element(var.allowed_ports, count.index)
  protocol          = var.protocol
  cidr_blocks       = var.allowed_ip
  security_group_id = join("", aws_security_group.security_group[*].id)
}

module "aws_kms_key" {
  count = var.kms_key_enabled && var.kms_key_id == "" ? 1 : 0

  source                  = "github.com/dedicatted/devops-tech//terraform/aws/modules/terraform-aws-kms"
  deletion_window_in_days = var.deletion_window_in_days
  key_administrators = [
    data.aws_caller_identity.current.arn,
  ]
}

resource "aws_cloudwatch_log_group" "aws_cloudwatch_log_group" {
  count             = var.enable && length(var.log_delivery_configuration) > 0 ? 1 : 0
  name              = format("logs-%s", var.name)
  retention_in_days = var.retention_in_days
  tags              = var.tags
}

resource "random_password" "auth_token" {
  count   = var.auth_token_enable && var.auth_token == null ? 1 : 0
  length  = var.length
  special = var.special
}

resource "aws_elasticache_replication_group" "cluster_replication" {
  count = var.enable && var.cluster_replication_enabled ? 1 : 0

  engine                     = var.engine
  replication_group_id       = var.name
  description                = var.replication_group_description
  engine_version             = var.engine_version
  port                       = var.port
  parameter_group_name       = var.parameter_group_name
  node_type                  = var.node_type
  automatic_failover_enabled = var.automatic_failover_enabled
  subnet_group_name          = var.subnet_group_names
  security_group_ids         = length(var.sg_ids) < 1 ? aws_security_group.security_group[*].id : var.sg_ids
  security_group_names       = var.security_group_names
  snapshot_arns              = var.snapshot_arns
  snapshot_name              = var.snapshot_name
  notification_topic_arn     = var.notification_topic_arn
  snapshot_window            = var.snapshot_window
  snapshot_retention_limit   = var.snapshot_retention_limit
  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  maintenance_window         = var.maintenance_window
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  multi_az_enabled           = var.multi_az_enabled
  auth_token                 = var.auth_token_enable ? (var.auth_token == null ? random_password.auth_token[0].result : var.auth_token) : null
  kms_key_id                 = var.kms_key_id == "" ? join("", module.aws_kms_key[*].key_arn) : var.kms_key_id
  tags                       = var.tags
  num_cache_clusters         = var.num_cache_clusters
  user_group_ids             = var.user_group_ids

  dynamic "log_delivery_configuration" {
    for_each = var.log_delivery_configuration

    content {
      destination      = lookup(log_delivery_configuration.value, "destination", join("", aws_cloudwatch_log_group.aws_cloudwatch_log_group[*].name))
      destination_type = lookup(log_delivery_configuration.value, "destination_type", null)
      log_format       = lookup(log_delivery_configuration.value, "log_format", null)
      log_type         = lookup(log_delivery_configuration.value, "log_type", null)
    }
  }
}

resource "aws_elasticache_cluster" "cluster" {
  count                        = var.enable && var.cluster_enabled ? 1 : 0
  engine                       = var.engine
  cluster_id                   = var.name
  engine_version               = var.engine_version
  port                         = var.port
  num_cache_nodes              = var.num_cache_nodes
  az_mode                      = var.az_mode
  parameter_group_name         = var.parameter_group_name
  node_type                    = var.node_type
  subnet_group_name            = var.subnet_group_names
  security_group_ids           = length(var.sg_ids) < 1 ? aws_security_group.security_group[*].id : var.sg_ids
  snapshot_arns                = var.snapshot_arns
  snapshot_name                = var.snapshot_name
  notification_topic_arn       = var.notification_topic_arn
  snapshot_window              = var.snapshot_window
  snapshot_retention_limit     = var.snapshot_retention_limit
  apply_immediately            = var.apply_immediately
  preferred_availability_zones = slice(var.availability_zones, 0, var.num_cache_nodes)
  maintenance_window           = var.maintenance_window
  tags                         = var.tags

}