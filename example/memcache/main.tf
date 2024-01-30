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

module "memcached" {
  source               = "github.com/dedicatted/terraform-aws-redis"
  name                 = "${var.name}-memcached"
  environment          = var.environment
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
  subnet_group_names   = module.vpc.elasticache_subnet_group_name
  subnet_ids           = module.vpc.elasticache_subnets
  availability_zones   = slice(data.aws_availability_zones.available.names, 0, 3)
  tags = {
    "environment" = var.environment
  }

}