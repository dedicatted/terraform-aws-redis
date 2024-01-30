output "redis_endpoint" {
  value       = var.cluster_replication_enabled ? "" : (var.cluster_replication_enabled ? join("", aws_elasticache_replication_group.cluster_replication[*].primary_endpoint_address) : join("", aws_elasticache_cluster.cluster[*].configuration_endpoint))
  description = "Redis endpoint address."
}

output "redis_arn" {
  value       = length(aws_elasticache_replication_group.cluster_replication) > 0 ? aws_elasticache_replication_group.cluster_replication[0].arn : length(aws_elasticache_replication_group.cluster_replication) > 0 ? aws_elasticache_replication_group.cluster_replication[0].arn : ""
  description = "Redis arn"
}

output "memcached_endpoint" {
  value       = var.cluster_enabled ? join("", aws_elasticache_cluster.cluster[*].configuration_endpoint) : ""
  description = "Memcached endpoint address."
}

output "memcached_arn" {
  value       = length(aws_elasticache_cluster.cluster) > 0 ? aws_elasticache_cluster.cluster[0].arn : ""
  description = "Memcached arn"
}

output "auth_token" {
  value       = var.auth_token_enable ? random_password.auth_token[0].result : ""
  sensitive   = true
  description = "Auth token generated value"
}
output "id" {
  value       = var.cluster_enabled ? "" : (var.cluster_replication_enabled ? join("", aws_elasticache_replication_group.cluster_replication[*].id) : join("", aws_elasticache_replication_group.cluster_replication[*].id))
  description = "Redis cluster id."
}