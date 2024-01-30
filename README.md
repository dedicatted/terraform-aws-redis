# terraform AWS Elasticache
This module used for creation any entety which enabled in AWS Elasticache (Redis, Memcached, Redis-cluster). Bellow we add some basic example of creation this entety. For more detail you can forward to example folder copy code from important folder and run it.
## Usage
Memcached
```hcl
module "memcached" {
  source = "/home/user/terraform-aws-redis"

  name        = "example"
  environment = "example"
  vpc_id        = "vpc-12312312"
  allowed_ip    = ["192.168.0.12"]
  allowed_ports = [11211]

  cluster_enabled                          = true
  engine                                   = "memcached"
  engine_version                           = "1.6.17"
  parameter_group_name                     = ""
  az_mode                                  = "cross-az"
  port                                     = 11211
  node_type                                = "cache.t2.micro"
  num_cache_nodes                          = 2
  subnet_ids                               = "sub-123123213"
  availability_zones                       = slice(data.aws_availability_zones.available.names, 0, 3)
  tags ={
    "environment" = "example"
  }
}
```
Redis
```hcl
module "redis" {
  source = "/home/user/terraform-aws-redis"


  name        = "example"
  environment = "example"
  vpc_id        = "vpc-12312312"
  allowed_ip    = ["192.168.0.12"]
  allowed_ports = [6379]

  cluster_replication_enabled = true
  engine                      = "redis"
  engine_version              = "7.0"
  parameter_group_name        = "default.redis7"
  port                        = 6379
  node_type                   = "cache.t2.micro"
  subnet_ids                  = "sub-123123213"
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
  tags ={
    "environment" = "example"
  }
}
```
Redis-cluster
```hcl
module "redis-cluster" {
  source = "/home/user/terraform-aws-redis"

  name        = "example"
  environment = "example"
  vpc_id        = "vpc-12312312"
  allowed_ip    = ["192.168.0.12"]
  allowed_ports = [6379]

  cluster_replication_enabled = true
  engine                      = "redis"
  engine_version              = "7.0"
  parameter_group_name        = "default.redis7.cluster.on"
  port                        = 6379
  node_type                   = "cache.t2.micro"
  subnet_ids                  = "sub-123123213"
  availability_zones          = slice(data.aws_availability_zones.available.names, 0, 3)
  num_cache_nodes             = 1
  snapshot_retention_limit    = 7
  automatic_failover_enabled  = true
  tags = {
    "environment" = "example"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.31.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.31.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_kms_key"></a> [aws\_kms\_key](#module\_aws\_kms\_key) | github.com/dedicatted/devops-tech//terraform/aws/modules/terraform-aws-kms | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.aws_cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_elasticache_replication_group.cluster_replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.aws_elasticache_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_security_group.security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [random_password.auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ip"></a> [allowed\_ip](#input\_allowed\_ip) | List of allowed ip. | `list(any)` | `[]` | no |
| <a name="input_allowed_ports"></a> [allowed\_ports](#input\_allowed\_ports) | List of allowed ingress ports | `list(any)` | `[]` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any modifications are applied immediately, or during the next maintenance window. Default is false. | `bool` | `false` | no |
| <a name="input_at_rest_encryption_enabled"></a> [at\_rest\_encryption\_enabled](#input\_at\_rest\_encryption\_enabled) | Enable encryption at rest. | `bool` | `true` | no |
| <a name="input_auth_token"></a> [auth\_token](#input\_auth\_token) | The password used to access a password protected server. Can be specified only if transit\_encryption\_enabled = true. Find auto generated auth\_token in terraform.tfstate or in AWS SSM Parameter Store. | `string` | `null` | no |
| <a name="input_auth_token_enable"></a> [auth\_token\_enable](#input\_auth\_token\_enable) | Flag to specify whether to create auth token (password) protected cluster. Can be specified only if transit\_encryption\_enabled = true. | `bool` | `true` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Specifies whether a minor engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. Defaults to true. | `bool` | `true` | no |
| <a name="input_automatic_failover_enabled"></a> [automatic\_failover\_enabled](#input\_automatic\_failover\_enabled) | Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If true, Multi-AZ is enabled for this replication group. If false, Multi-AZ is disabled for this replication group. Must be enabled for Redis (cluster mode enabled) replication groups. Defaults to false. | `bool` | `true` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | A list of EC2 availability zones in which the replication group's cache clusters will be created. The order of the availability zones in the list is not important. | `list(string)` | n/a | yes |
| <a name="input_az_mode"></a> [az\_mode](#input\_az\_mode) | (Memcached only) Specifies whether the nodes in this Memcached node group are created in a single Availability Zone or created across multiple Availability Zones in the cluster's region. Valid values for this parameter are single-az or cross-az, default is single-az. If you want to choose cross-az, num\_cache\_nodes must be greater than 1. | `string` | `"single-az"` | no |
| <a name="input_cluster_enabled"></a> [cluster\_enabled](#input\_cluster\_enabled) | (Memcache only) Enabled or disabled cluster. | `bool` | `false` | no |
| <a name="input_cluster_replication_enabled"></a> [cluster\_replication\_enabled](#input\_cluster\_replication\_enabled) | (Redis only) Enabled or disabled replication\_group for redis cluster. | `bool` | `false` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | Duration in days after which the key is deleted after destruction of the resource. | `number` | `7` | no |
| <a name="input_egress_rule"></a> [egress\_rule](#input\_egress\_rule) | Enable to create egress rule | `bool` | `true` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | Enable or disable of elasticache | `bool` | `true` | no |
| <a name="input_enable_security_group"></a> [enable\_security\_group](#input\_enable\_security\_group) | Enable default Security Group with only Egress traffic allowed. | `bool` | `true` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The name of the cache engine to be used for the clusters in this replication group. e.g. redis. | `string` | `""` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The version number of the cache engine to be used for the cache clusters in this replication group. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_is_external"></a> [is\_external](#input\_is\_external) | enable to udated existing security Group | `bool` | `false` | no |
| <a name="input_kms_key_enabled"></a> [kms\_key\_enabled](#input\_kms\_key\_enabled) | Specifies whether the kms is enabled or disabled. | `bool` | `true` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if at\_rest\_encryption\_enabled = true. | `string` | `""` | no |
| <a name="input_length"></a> [length](#input\_length) | n/a | `number` | `25` | no |
| <a name="input_log_delivery_configuration"></a> [log\_delivery\_configuration](#input\_log\_delivery\_configuration) | The log\_delivery\_configuration block allows the streaming of Redis SLOWLOG or Redis Engine Log to CloudWatch Logs or Kinesis Data Firehose. Max of 2 blocks. | `list(map(any))` | `[]` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window. | `string` | `"sun:05:00-sun:06:00"` | no |
| <a name="input_multi_az_enabled"></a> [multi\_az\_enabled](#input\_multi\_az\_enabled) | Specifies whether to enable Multi-AZ Support for the replication group. If true, automatic\_failover\_enabled must also be enabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of resources related to redis cluster. | `string` | `"redis"` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | The compute and memory capacity of the nodes in the node group. | `string` | `"cache.t2.small"` | no |
| <a name="input_notification_topic_arn"></a> [notification\_topic\_arn](#input\_notification\_topic\_arn) | An Amazon Resource Name (ARN) of an SNS topic to send ElastiCache notifications to. | `string` | `""` | no |
| <a name="input_num_cache_clusters"></a> [num\_cache\_clusters](#input\_num\_cache\_clusters) | (Required for Cluster Mode Disabled) The number of cache clusters (primary and replicas) this replication group will have. If Multi-AZ is enabled, the value of this parameter must be at least 2. Updates will occur before other modifications. | `number` | `1` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | (Required unless replication\_group\_id is provided) The initial number of cache nodes that the cache cluster will have. For Redis, this value must be 1. For Memcache, this value must be between 1 and 20. If this number is reduced on subsequent runs, the highest numbered nodes will be removed. | `number` | `1` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | The name of the parameter group to associate with this replication group. If this argument is omitted, the default cache parameter group for the specified engine is used. | `string` | `"default.redis5.0"` | no |
| <a name="input_port"></a> [port](#input\_port) | the port number on which each of the cache nodes will accept connections. | `string` | `""` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | The protocol. If not icmp, tcp, udp, or all use the. | `string` | `"tcp"` | no |
| <a name="input_replication_group_description"></a> [replication\_group\_description](#input\_replication\_group\_description) | Name of either the CloudWatch Logs LogGroup or Kinesis Data Firehose resource. | `string` | `"User-created description for the replication group."` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. | `number` | `0` | no |
| <a name="input_security_group_names"></a> [security\_group\_names](#input\_security\_group\_names) | A list of cache security group names to associate with this replication group. | `list(string)` | `null` | no |
| <a name="input_sg_description"></a> [sg\_description](#input\_sg\_description) | The security group description. | `string` | `"Instance default security group (only egress access is allowed)."` | no |
| <a name="input_sg_egress_description"></a> [sg\_egress\_description](#input\_sg\_egress\_description) | Description of the egress and ingress rule | `string` | `"Description of the rule."` | no |
| <a name="input_sg_egress_ipv6_description"></a> [sg\_egress\_ipv6\_description](#input\_sg\_egress\_ipv6\_description) | Description of the egress\_ipv6 rule | `string` | `"Description of the rule."` | no |
| <a name="input_sg_ids"></a> [sg\_ids](#input\_sg\_ids) | of the security group id. | `list(any)` | `[]` | no |
| <a name="input_sg_ingress_description"></a> [sg\_ingress\_description](#input\_sg\_ingress\_description) | Description of the ingress rule | `string` | `"Description of the ingress rule use elasticache."` | no |
| <a name="input_snapshot_arns"></a> [snapshot\_arns](#input\_snapshot\_arns) | A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. | `list(string)` | `null` | no |
| <a name="input_snapshot_name"></a> [snapshot\_name](#input\_snapshot\_name) | The name of a snapshot from which to restore data into the new node group. Changing the snapshot\_name forces a new resource. | `string` | `""` | no |
| <a name="input_snapshot_retention_limit"></a> [snapshot\_retention\_limit](#input\_snapshot\_retention\_limit) | (Redis only) The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot\_retention\_limit is not supported on cache.t1.micro or cache.t2.* cache nodes. | `string` | `"0"` | no |
| <a name="input_snapshot_window"></a> [snapshot\_window](#input\_snapshot\_window) | (Redis only) The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period. | `string` | `null` | no |
| <a name="input_special"></a> [special](#input\_special) | n/a | `bool` | `false` | no |
| <a name="input_subnet_group_description"></a> [subnet\_group\_description](#input\_subnet\_group\_description) | Description for the cache subnet group. Defaults to `Managed by Terraform`. | `string` | `"The Description of the ElastiCache Subnet Group."` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of VPC Subnet IDs for the cache subnet group. | `list(any)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags for all resource which created by this module | `map(any)` | n/a | yes |
| <a name="input_transit_encryption_enabled"></a> [transit\_encryption\_enabled](#input\_transit\_encryption\_enabled) | Whether to enable encryption in transit. | `bool` | `true` | no |
| <a name="input_user_group_ids"></a> [user\_group\_ids](#input\_user\_group\_ids) | User Group ID to associate with the replication group. | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC that the instance security group belongs to. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_auth_token"></a> [auth\_token](#output\_auth\_token) | Auth token generated value |
| <a name="output_id"></a> [id](#output\_id) | Redis cluster id. |
| <a name="output_memcached_arn"></a> [memcached\_arn](#output\_memcached\_arn) | Memcached arn |
| <a name="output_memcached_endpoint"></a> [memcached\_endpoint](#output\_memcached\_endpoint) | Memcached endpoint address. |
| <a name="output_redis_arn"></a> [redis\_arn](#output\_redis\_arn) | Redis arn |
| <a name="output_redis_endpoint"></a> [redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint address. |
