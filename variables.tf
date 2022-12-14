## NAMING
variable "name" {
  description = "Name of the Security Group and Prefix."
  type        = string
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

## SG
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
    source_security_group_id = optional(string)

    self = optional(bool)
  }))

  validation {
    condition     = alltrue([for rule in var.ingress_rules : false if rule.cidr_blocks != null && rule.source_security_group_id != null])
    error_message = "A rule can either have 'cidr_blocks' or 'source_security_group_id' but not both."
  }

  validation {
    condition     = alltrue([for rule in var.ingress_rules : false if rule.port != null && (rule.to_port != null || rule.from_port != null)])
    error_message = "A rule can either have 'port' or 'to_port'|'from_port' but not both."
  }

  validation {
    condition     = alltrue([for rule in var.ingress_rules : false if rule.self != null && (rule.cidr_blocks != null || rule.source_security_group_id != null)])
    error_message = "A rule can either have 'self' or 'cidr_blocks'|'source_security_group_id' but not both."
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
    source_security_group_id = optional(string)

    self = optional(bool)
  }))

  validation {
    condition     = alltrue([for rule in var.egress_rules : false if rule.cidr_blocks != null && rule.source_security_group_id != null])
    error_message = "A rule can either have 'cidr_blocks' or 'source_security_group_id' but not both."
  }

  validation {
    condition     = alltrue([for rule in var.egress_rules : false if rule.port != null && (rule.to_port != null || rule.from_port != null)])
    error_message = "A rule can either have 'port' or 'to_port'|'from_port' but not both."
  }

  validation {
    condition     = alltrue([for rule in var.egress_rules : false if rule.self != null && (rule.cidr_blocks != null || rule.source_security_group_id != null)])
    error_message = "A rule can either have 'self' or 'cidr_blocks'|'source_security_group_id' but not both."
  }
}
