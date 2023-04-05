/**
 * # Terraform AWS Security Group
 *
 * Introducing the AWS Security Group Terraform Module, a simple and easy-to-use solution for creating and managing
 * your security groups within Amazon Web Services (AWS). This module has been designed with ease of use in mind,
 * providing you with a straightforward way to create and manage your security groups.
 *
 * Our team of experts has years of experience working with AWS security groups and has a deep understanding of the
 * best practices and configurations. By using this Terraform module, you can be sure that your security groups are
 * created and managed in a secure and efficient manner.
 *
 * This module offers a preconfigured solution for creating security groups and the ingress or egress rules that belong
 * to them, saving you time and effort in the process. Whether you're looking to secure your resources or to limit the
 * access to your applications, this module has you covered.
 *
 * So, if you're looking for a convenient and reliable solution for creating and managing your security groups within
 * AWS, look no further than the AWS Security Group Terraform Module. Give it a try and see how easy it is to create
 * and manage your security groups!
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
  for_each = {
    for rule in var.ingress_rules : format(
      "ingress-%s-%s-%s-%s",
      rule.protocol,
      coalesce(rule.port, rule.from_port),
      coalesce(rule.port, rule.to_port),
      coalesce(rule.source_security_group_id, join("_", coalesce(rule.cidr_blocks, [])), "self")
    ) => rule
  }

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
  for_each = {
    for rule in var.egress_rules : format(
      "egress-%s-%s-%s-%s",
      rule.protocol,
      coalesce(rule.port, rule.from_port),
      coalesce(rule.port, rule.to_port),
      coalesce(rule.source_security_group_id, join("_", coalesce(rule.cidr_blocks, [])), "self")
    ) => rule
  }

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
