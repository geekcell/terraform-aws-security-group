![Geek Cell GmbH](https://uploads-ssl.webflow.com/61d1d8051145e270217e36a1/61d205833226d492ab02ad46_Group%202.svg "Geek Cell GmbH")

It's 100% Open Source and licensed under the [APACHE2](LICENSE).

<!-- BEGIN_TF_DOCS -->
# Terraform AWS Security Group Module

Terraform module which creates a Security Group with rules attached to it.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the Security Group. | `string` | `null` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | Egress rules to add to the Security Group. See examples for usage. | <pre>list(object({<br>    protocol    = string<br>    description = optional(string)<br><br>    port      = optional(number)<br>    to_port   = optional(number)<br>    from_port = optional(number)<br><br>    cidr_blocks              = optional(list(string))<br>    source_security_group_id = optional(string)<br><br>    self = optional(bool)<br>  }))</pre> | `[]` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | Ingress rules to add to the Security Group. See examples for usage. | <pre>list(object({<br>    protocol    = string<br>    description = optional(string)<br><br>    port      = optional(number)<br>    to_port   = optional(number)<br>    from_port = optional(number)<br><br>    cidr_blocks              = optional(list(string))<br>    source_security_group_id = optional(string)<br><br>    self = optional(bool)<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Security Group and Prefix. | `string` | n/a | yes |
| <a name="input_revoke_rules_on_delete"></a> [revoke\_rules\_on\_delete](#input\_revoke\_rules\_on\_delete) | Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself. This is normally not needed. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to add to the Security Group. | `map(any)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID where resources are created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Security Group ID |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.36 |

## Resources

- resource.aws_security_group.main (main.tf#7)
- resource.aws_security_group_rule.main_egress (main.tf#31)
- resource.aws_security_group_rule.main_ingress (main.tf#16)

# Examples
### Full
```hcl
module "example" {
  source = "../../"

  vpc_id      = "vpc-12345678910"
  name        = "application-rds"
  description = "Attached to Application RDS"

  ingress_rules = [
    # To/From ports are the same
    {
      port        = 3306
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },

    # Different To/From ports
    {
      from_port   = 3306
      to_port     = 54321
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },

    # Allow other SG instead of CIDR
    {
      port                     = 3306
      protocol                 = "udp"
      source_security_group_id = "sg-1234567891011"
    }
  ]

  egress_rules = [
    # Same arguments as `ingress_rules`
  ]
}
```
<!-- END_TF_DOCS -->
