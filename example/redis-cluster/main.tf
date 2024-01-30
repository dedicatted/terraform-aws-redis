provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source                             = "github.com/terraform-aws-modules/terraform-aws-vpc"
  name                               = "${var.name}-vpc"
  cidr                               = var.cidr_block
  azs                                = slice(data.aws_availability_zones.available.names, 0, 3)
  database_subnets                   = [cidrsubnet(var.cidr_block, 8, 6), cidrsubnet(var.cidr_block, 8, 7), cidrsubnet(var.cidr_block, 8, 8)]
  create_database_subnet_group       = true
  create_database_subnet_route_table = true
}

module "redis-cluster" {
  source                      = "github.com/dedicatted/terraform-aws-redis"
  name                        = var.name
  environment                 = var.environment
  vpc_id                      = module.vpc.vpc_id
  allowed_ip                  = [var.cidr_block]
  allowed_ports               = [6379]
  cluster_replication_enabled = true
  engine                      = "redis"
  engine_version              = "7.0"
  parameter_group_name        = "default.redis7.cluster.on"
  port                        = 6379
  node_type                   = "cache.t2.micro"
  subnet_ids                  = module.vpc.database_subnets
  availability_zones          = slice(data.aws_availability_zones.available.names, 0, 3)
  num_cache_nodes             = 1
  snapshot_retention_limit    = 7
  automatic_failover_enabled  = true
  tags = {
    "environment" = var.environment
  }
}