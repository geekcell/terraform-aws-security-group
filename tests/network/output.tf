output "vpc_id" {
  value = aws_default_vpc.default.id
}

output "security_group_id" {
  value = aws_default_security_group.default.id
}

output "prefix_list_id" {
  value = aws_ec2_managed_prefix_list.main.id
}
