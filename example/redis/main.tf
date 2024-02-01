provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source                                = "github.com/terraform-aws-modules/terraform-aws-vpc"
  name                                  = "${var.name}-vpc"
  cidr                                  = var.cidr_block
  azs                                   = slice(data.aws_availability_zones.available.names, 0, 3)
  elasticache_subnets                   = [cidrsubnet(var.cidr_block, 8, 6), cidrsubnet(var.cidr_block, 8, 7), cidrsubnet(var.cidr_block, 8, 8)]
  elasticache_subnet_names              = ["${var.name}-subnet-one", "${var.name}-subnet-two", "${var.name}-subnet-three"]
  create_elasticache_subnet_route_table = true
  create_elasticache_subnet_group       = true
}

module "redis" {
  source                      = "github.com/dedicatted/terraform-aws-redis"
  name                        = "${var.name}-redis"
  environment                 = var.environment
  vpc_id                      = module.vpc.vpc_id
  allowed_ip                  = [var.cidr_block]
  allowed_ports               = [6379]
  cluster_replication_enabled = true
  engine                      = "redis"
  engine_version              = "7.0"
  parameter_group_name        = "default.redis7"
  port                        = 6379
  node_type                   = "cache.t2.micro"
  subnet_group_names          = module.vpc.elasticache_subnet_group_name
  subnet_ids                  = module.vpc.elasticache_subnets
  availability_zones          = slice(data.aws_availability_zones.available.names, 0, 3)
  automatic_failover_enabled  = false
  multi_az_enabled            = false
  num_cache_clusters          = 1
  retention_in_days           = 0
  snapshot_retention_limit    = 7
  log_delivery_configuration = [
    {
      destination_type = "cloudwatch-logs"
      log_format       = "json"
      log_type         = "slow-log"
    },
    {
      destination_type = "cloudwatch-logs"
      log_format       = "json"
      log_type         = "engine-log"
    }
  ]
  tags = {
    "environment" = var.environment
  }
}