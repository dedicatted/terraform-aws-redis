output "id" {
  value       = module.redis[*].id
  description = "Redis cluster id."
}

output "redis_endpoint" {
  value       = module.redis.redis_endpoint
  description = "Redis endpoint address."
}
output "auth_token" {
  value     = module.redis.auth_token
  sensitive = true
}