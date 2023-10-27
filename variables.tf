## NAMING
variable "name" {
  description = "Name of the Security Group and Prefix."
  type        = string
}

variable "name_prefix" {
  description = "Whether to use the name as prefix or regular name."
  default     = true
  type        = bool
}

variable "description" {
  description = "Description of the Security Group."
  default     = null
  type        = string
}

variable "tags" {
  description = "Tags to add to the Security Group."
  default     = {}
  type        = map(any)
}

## Security Group
variable "vpc_id" {
  description = "The VPC ID where resources are created."
  type        = string
}

variable "revoke_rules_on_delete" {
  description = "Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself. This is normally not needed."
  default     = false
  type        = bool
}

variable "ingress_rules" {
  description = "Ingress rules to add to the Security Group. See examples for usage."
  default     = []
  type = list(object({
    protocol    = string
    description = optional(string)

    port      = optional(number)
    to_port   = optional(number)
    from_port = optional(number)

    cidr_blocks              = optional(list(string))
    prefix_list_ids          = optional(list(string))
    source_security_group_id = optional(string)
    self                     = optional(bool)
  }))

  validation {
    # Only one of these can be set. Filter out null values and check if the length is greater than 1.
    condition = alltrue([
      for rule in var.ingress_rules :
      false
      if length([for k, v in [rule.self, rule.cidr_blocks, rule.source_security_group_id, rule.prefix_list_ids] : k if v != null]) > 1
    ])
    error_message = "A rule can either have 'cidr_blocks', 'prefix_list_ids', 'source_security_group_id' or 'self'."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress_rules :
      false
      if rule.port != null && (rule.to_port != null || rule.from_port != null)
    ])
    error_message = "A rule can either have 'port' or 'to_port'|'from_port' but not both."
  }
}

variable "egress_rules" {
  description = "Egress rules to add to the Security Group. See examples for usage."
  default     = []
  type = list(object({
    protocol    = string
    description = optional(string)

    port      = optional(number)
    to_port   = optional(number)
    from_port = optional(number)

    cidr_blocks              = optional(list(string))
    prefix_list_ids          = optional(list(string))
    source_security_group_id = optional(string)
    self                     = optional(bool)
  }))

  validation {
    # Only one of these can be set. Filter out null values and check if the length is greater than 1.
    condition = alltrue([
      for rule in var.egress_rules :
      false
      if length([for k, v in [rule.self, rule.cidr_blocks, rule.source_security_group_id, rule.prefix_list_ids] : k if v != null]) > 1
    ])
    error_message = "A rule can either have 'cidr_blocks', 'prefix_list_ids', 'source_security_group_id' or 'self'."
  }

  validation {
    condition = alltrue([
      for rule in var.egress_rules :
      false
      if rule.port != null && (rule.to_port != null || rule.from_port != null)
    ])
    error_message = "A rule can either have 'port' or 'to_port'|'from_port' but not both."
  }
}
