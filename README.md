<!-- BEGIN_TF_DOCS -->
[![Geek Cell GmbH](https://raw.githubusercontent.com/geekcell/template-terraform-module/main/docs/assets/logo.svg)](https://www.geekcell.io/)

### Code Quality
[![License](https://img.shields.io/github/license/geekcell/terraform-aws-security-group)](https://github.com/geekcell/terraform-aws-security-group/blob/master/LICENSE)
[![GitHub release (latest tag)](https://img.shields.io/github/v/release/geekcell/terraform-aws-security-group?logo=github&sort=semver)](https://github.com/geekcell/terraform-aws-security-group/releases)
[![Release](https://github.com/geekcell/terraform-aws-security-group/actions/workflows/release.yaml/badge.svg)](https://github.com/geekcell/terraform-aws-security-group/actions/workflows/release.yaml)
[![Validate](https://github.com/geekcell/terraform-aws-security-group/actions/workflows/validate.yaml/badge.svg)](https://github.com/geekcell/terraform-aws-security-group/actions/workflows/validate.yaml)
[![Lint](https://github.com/geekcell/terraform-aws-security-group/actions/workflows/linter.yaml/badge.svg)](https://github.com/geekcell/terraform-aws-security-group/actions/workflows/linter.yaml)

### Security
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/geekcell/terraform-aws-security-group/general)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=geekcell%2Fterraform-aws-security-group&benchmark=INFRASTRUCTURE+SECURITY)

#### Cloud
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/geekcell/terraform-aws-security-group/cis_aws)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=geekcell%2Fterraform-aws-security-group&benchmark=CIS+AWS+V1.2)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/geekcell/terraform-aws-security-group/cis_aws_13)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=geekcell%2Fterraform-aws-security-group&benchmark=CIS+AWS+V1.3)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/geekcell/terraform-aws-security-group/cis_azure)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=geekcell%2Fterraform-aws-security-group&benchmark=CIS+AZURE+V1.1)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/geekcell/terraform-aws-security-group/cis_azure_13)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=geekcell%2Fterraform-aws-security-group&benchmark=CIS+AZURE+V1.3)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/geekcell/terraform-aws-security-group/cis_gcp)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=geekcell%2Fterraform-aws-security-group&benchmark=CIS+GCP+V1.1)

##### Container
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/geekcell/terraform-aws-security-group/cis_kubernetes_16)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=geekcell%2Fterraform-aws-security-group&benchmark=CIS+KUBERNETES+V1.6)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/geekcell/terraform-aws-security-group/cis_eks_11)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=geekcell%2Fterraform-aws-security-group&benchmark=CIS+EKS+V1.1)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/geekcell/terraform-aws-security-group/cis_gke_11)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=geekcell%2Fterraform-aws-security-group&benchmark=CIS+GKE+V1.1)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/geekcell/terraform-aws-security-group/cis_kubernetes)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=geekcell%2Fterraform-aws-security-group&benchmark=CIS+KUBERNETES+V1.5)

#### Data protection
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/geekcell/terraform-aws-security-group/soc2)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=geekcell%2Fterraform-aws-security-group&benchmark=SOC2)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/geekcell/terraform-aws-security-group/pci)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=geekcell%2Fterraform-aws-security-group&benchmark=PCI-DSS+V3.2)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/geekcell/terraform-aws-security-group/pci_dss_v321)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=geekcell%2Fterraform-aws-security-group&benchmark=PCI-DSS+V3.2.1)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/geekcell/terraform-aws-security-group/iso)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=geekcell%2Fterraform-aws-security-group&benchmark=ISO27001)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/geekcell/terraform-aws-security-group/nist)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=geekcell%2Fterraform-aws-security-group&benchmark=NIST-800-53)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/geekcell/terraform-aws-security-group/hipaa)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=geekcell%2Fterraform-aws-security-group&benchmark=HIPAA)
[![Infrastructure Tests](https://www.bridgecrew.cloud/badges/github/geekcell/terraform-aws-security-group/fedramp_moderate)](https://www.bridgecrew.cloud/link/badge?vcs=github&fullRepo=geekcell%2Fterraform-aws-security-group&benchmark=FEDRAMP+%28MODERATE%29)

# Terraform AWS Security Group

Introducing the AWS Security Group Terraform Module, a simple and easy-to-use solution for creating and managing
your security groups within Amazon Web Services (AWS). This module has been designed with ease of use in mind,
providing you with a straightforward way to create and manage your security groups.

Our team of experts has years of experience working with AWS security groups and has a deep understanding of the
best practices and configurations. By using this Terraform module, you can be sure that your security groups are
created and managed in a secure and efficient manner.

This module offers a preconfigured solution for creating security groups and the ingress or egress rules that belong
to them, saving you time and effort in the process. Whether you're looking to secure your resources or to limit the
access to your applications, this module has you covered.

So, if you're looking for a convenient and reliable solution for creating and managing your security groups within
AWS, look no further than the AWS Security Group Terraform Module. Give it a try and see how easy it is to create
and manage your security groups!

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the Security Group. | `string` | `null` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | Egress rules to add to the Security Group. See examples for usage. | <pre>list(object({<br>    protocol    = string<br>    description = optional(string)<br><br>    port      = optional(number)<br>    to_port   = optional(number)<br>    from_port = optional(number)<br><br>    cidr_blocks              = optional(list(string))<br>    source_security_group_id = optional(string)<br><br>    self = optional(bool)<br>  }))</pre> | `[]` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | Ingress rules to add to the Security Group. See examples for usage. | <pre>list(object({<br>    protocol    = string<br>    description = optional(string)<br><br>    port      = optional(number)<br>    to_port   = optional(number)<br>    from_port = optional(number)<br><br>    cidr_blocks              = optional(list(string))<br>    source_security_group_id = optional(string)<br><br>    self = optional(bool)<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Security Group and Prefix. | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Whether to use the name as prefix or regular name. | `bool` | `true` | no |
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

- resource.aws_security_group.main (main.tf#42)
- resource.aws_security_group_rule.main_egress (main.tf#70)
- resource.aws_security_group_rule.main_ingress (main.tf#54)

# Examples
### Full
```hcl
module "full" {
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
      cidr_blocks = ["127.0.0.0/8", "10.0.0.0/8"]
    },

    # Allow other SG instead of CIDR
    {
      port                     = 3306
      protocol                 = "udp"
      source_security_group_id = "sg-1234567891011"
    },

    # Using self
    {
      port     = 3306
      protocol = "udp"
      self     = true
    }
  ]

  egress_rules = [
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
      cidr_blocks = ["127.0.0.0/8", "10.0.0.0/8"]
    },

    # Allow other SG instead of CIDR
    {
      port                     = 3306
      protocol                 = "udp"
      source_security_group_id = "sg-1234567891011"
    },

    # Using self
    {
      port     = 3306
      protocol = "udp"
      self     = true
    }
  ]
}
```
<!-- END_TF_DOCS -->
