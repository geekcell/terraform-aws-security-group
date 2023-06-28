module "vpc" {
  source  = "registry.terraform.io/terraform-aws-modules/vpc/aws"
  version = "~> 5.0.0"

  name = "${var.name}-main"
  cidr = "10.100.0.0/16"
}

module "source_security_group" {
  source = "../../"

  name   = var.name
  vpc_id = module.vpc.vpc_id
}

module "full" {
  source = "../../"

  vpc_id      = module.vpc.vpc_id
  name        = var.name
  description = "Testing Terraform full example"

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
      source_security_group_id = module.source_security_group.security_group_id
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
      source_security_group_id = module.source_security_group.security_group_id
    },

    # Using self
    {
      port     = 3306
      protocol = "udp"
      self     = true
    }
  ]
}
