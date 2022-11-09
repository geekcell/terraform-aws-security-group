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
