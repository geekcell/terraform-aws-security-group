/**
 * # Terraform AWS Security Group
 *
 * Terraform module to create a Security Group with ingress and egress rules in one go.
 */
resource "aws_security_group" "main" {
  #bridgecrew:skip=BC_AWS_NETWORKING_51:This module create Security Groups only. The attachment has to be done in the parent module.

  name                   = var.name_prefix ? null : var.name
  name_prefix            = var.name_prefix ? "${var.name}-" : null
  description            = coalesce(var.description, "Security Group for ${var.name}")
  vpc_id                 = var.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete

  tags = merge({ Name = var.name }, var.tags)
}

resource "aws_security_group_rule" "main_ingress" {
  for_each = { for index, rule in var.ingress_rules : index => rule }

  description       = coalesce(each.value.description, "Allow ingress for ${each.value.protocol}-${coalesce(each.value.port, each.value.from_port)}")
  security_group_id = aws_security_group.main.id
  type              = "ingress"

  protocol  = each.value.protocol
  from_port = coalesce(each.value.port, each.value.from_port)
  to_port   = coalesce(each.value.port, each.value.to_port)

  self                     = each.value.self
  cidr_blocks              = each.value.cidr_blocks
  prefix_list_ids          = each.value.prefix_list_ids
  source_security_group_id = each.value.source_security_group_id
}

resource "aws_security_group_rule" "main_egress" {
  for_each = { for index, rule in var.egress_rules : index => rule }

  description       = coalesce(each.value.description, "Allow egress for ${each.value.protocol}-${coalesce(each.value.port, each.value.from_port)}")
  security_group_id = aws_security_group.main.id
  type              = "egress"

  protocol  = each.value.protocol
  from_port = coalesce(each.value.port, each.value.from_port)
  to_port   = coalesce(each.value.port, each.value.to_port)

  self                     = each.value.self
  cidr_blocks              = each.value.cidr_blocks
  prefix_list_ids          = each.value.prefix_list_ids
  source_security_group_id = each.value.source_security_group_id
}
