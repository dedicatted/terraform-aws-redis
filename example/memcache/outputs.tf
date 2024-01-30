output "id" {
  value       = module.memcached[*].id
  description = "memcached id."
}

output "memcached_endpoint" {
  value       = module.memcached.memcached_endpoint
  description = "Memcached endpoint address."
}
output "auth_token" {
  value     = module.memcached.auth_token
  sensitive = true
}