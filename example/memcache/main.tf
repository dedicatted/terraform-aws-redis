provider "aws" {
  region = local.region
}
locals {
  name        = "memcache"
  environment = "test"
  region      = var.region
}
data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source                             = "github.com/terraform-aws-modules/terraform-aws-vpc"
  name                               = var.vpc_name
  cidr                               = var.cidr_block
  azs                                = slice(data.aws_availability_zones.available.names, 0, 3)
  database_subnets                   = [cidrsubnet(var.cidr_block, 8, 6), cidrsubnet(var.cidr_block, 8, 7), cidrsubnet(var.cidr_block, 8, 8)]
  create_database_subnet_group       = true
  create_database_subnet_route_table = true
}

module "memcached" {
  source = "github.com/dedicatted/terraform-aws-redis"

  name                 = local.name
  environment          = local.environment
  vpc_id               = module.vpc.vpc_id
  allowed_ip           = [var.cidr_block]
  allowed_ports        = [11211]
  cluster_enabled      = true
  engine               = "memcached"
  engine_version       = "1.6.17"
  parameter_group_name = ""
  az_mode              = "cross-az"
  port                 = 11211
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 2
  subnet_ids           = module.vpc.database_subnets
  availability_zones   = slice(data.aws_availability_zones.available.names, 0, 3)
  tags = {
    "environment" = local.environment
  }

}