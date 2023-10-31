run "setup" {
  module {
    source = "./tests/network"
  }
}

run "security_group_rule_validations" {
  command = plan

  variables {
    name        = "basic-security-group-3"
    description = "This is a test security group."

    vpc_id = run.setup.vpc_id
    ingress_rules = [
      # Self & CIDR Blocks are not possible
      {
        port        = 3306
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        self        = true
      }
    ]

    egress_rules = [
      # port and to_port not possible
      {
        port        = 3306
        to_port     = 3307
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  expect_failures = [
    var.ingress_rules,
    var.egress_rules
  ]
}
