output "security_group_id" {
  description = "Security group id"
  value       = module.full.security_group_id
}

output "source_security_group" {
  description = "Source security group id"
  value       = module.source_security_group.security_group_id
}
