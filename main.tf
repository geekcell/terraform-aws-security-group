/**
 * # Terraform AWS Security Group Module
 *
 * Terraform module which creates a Security Group and rules ingress or egress
 * rules that belong to it. The focus on this module lies within it's simplicity
 * by providing default values that should make sense for most use cases.
 *
 * It also makes use of the latest Terraform features like `optional` to provide
 * minimal required inputs and complexity.
 */
resource "aws_security_group" "main" {
  #bridgecrew:skip=BC_AWS_NETWORKING_51:This module create Security Groups only. The attachment has to be done in the parent module.

  name_prefix            = "${var.name}-"
  description            = coalesce(var.description, "Security Group for ${var.name}")
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  tags = merge({ Name = var.name }, var.tags)
}

resource "aws_security_group_rule" "main_ingress" {
  for_each = { for rule in var.ingress_rules : "ingress-${rule.protocol}-${coalesce(rule.port, rule.from_port)}-${coalesce(rule.port, rule.to_port)}" => rule }

  description       = coalesce(each.value.description, "Allow ingress for ${each.value.protocol}-${coalesce(each.value.port, each.value.from_port)}")
  security_group_id = aws_security_group.main.id
  type              = "ingress"

  protocol  = each.value.protocol
  from_port = coalesce(each.value.port, each.value.from_port)
  to_port   = coalesce(each.value.port, each.value.to_port)

  self                     = each.value.self
  cidr_blocks              = each.value.cidr_blocks
  source_security_group_id = each.value.source_security_group_id
}

resource "aws_security_group_rule" "main_egress" {
  for_each = { for rule in var.egress_rules : "egress-${rule.protocol}-${coalesce(rule.port, rule.from_port)}-${coalesce(rule.port, rule.to_port)}" => rule }

  description       = coalesce(each.value.description, "Allow egress for ${each.value.protocol}-${coalesce(each.value.port, each.value.from_port)}")
  security_group_id = aws_security_group.main.id
  type              = "egress"

  protocol  = each.value.protocol
  from_port = coalesce(each.value.port, each.value.from_port)
  to_port   = coalesce(each.value.port, each.value.to_port)

  self                     = each.value.self
  cidr_blocks              = each.value.cidr_blocks
  source_security_group_id = each.value.source_security_group_id
}
