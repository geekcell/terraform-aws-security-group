run "setup" {
  module {
    source = "./tests/network"
  }
}

run "basic_security_group_with_rules" {
  variables {
    name        = "basic-security-group"
    description = "This is a test security group."

    vpc_id = run.setup.vpc_id
    ingress_rules = [
      {
        port        = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    egress_rules = [
      {
        port        = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    tags = {
      SomeTag    = "foo"
      AnotherTag = "bar"
    }
  }

  assert {
    condition     = length(output.security_group_id) >= 0
    error_message = "Expected SG to be created."
  }

  assert {
    condition     = length(aws_security_group.main.tags) == 3
    error_message = "Expected SG to have 3 tags in total."
  }

  assert {
    condition     = length(aws_security_group_rule.main_ingress) == length(var.ingress_rules)
    error_message = "Expected SG to have 1 ingress rule."
  }

  assert {
    condition     = length(aws_security_group_rule.main_egress) == length(var.egress_rules)
    error_message = "Expected SG to have 1 egress rule."
  }
}

run "advanced_security_group_with_rules" {
  variables {
    name        = "basic-security-group-2"
    description = "This is a test security group."

    vpc_id = run.setup.vpc_id
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
        source_security_group_id = run.setup.security_group_id
      },

      # Using self
      {
        port     = 3306
        protocol = "udp"
        self     = true
      },

      # Using prefix list
      {
        port            = 443
        protocol        = "tcp"
        prefix_list_ids = [run.setup.prefix_list_id]
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
        source_security_group_id = run.setup.security_group_id
      },

      # Using self
      {
        port     = 3306
        protocol = "udp"
        self     = true
      },

      # Using prefix list
      {
        port            = 443
        protocol        = "tcp"
        prefix_list_ids = [run.setup.prefix_list_id]
      }
    ]
  }

  assert {
    condition     = length(output.security_group_id) >= 0
    error_message = "Expected SG to be created."
  }

  assert {
    condition     = length(aws_security_group_rule.main_ingress) == length(var.ingress_rules)
    error_message = "Expected SG to have 1 ingress rule."
  }

  assert {
    condition     = length(aws_security_group_rule.main_egress) == length(var.egress_rules)
    error_message = "Expected SG to have 1 egress rule."
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
