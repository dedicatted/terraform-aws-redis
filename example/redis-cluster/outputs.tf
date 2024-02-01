output "id" {
  value       = module.redis-cluster.id
  description = "Redis cluster id."
}

output "redis_endpoint" {
  value       = module.redis-cluster[*].redis_endpoint
  description = "Redis endpoint address."
}

output "auth_token" {
  value     = module.redis-cluster.auth_token
  sensitive = true
}