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
    error_message = "Expected security group to be created."
  }

  assert {
    condition     = length(aws_security_group.main.tags) == 3
    error_message = "Expected security group to have 3 tags in total."
  }

  assert {
    condition     = length(aws_security_group_rule.main_ingress) == 1
    error_message = "Expected security group to have 1 ingress rule."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[0].protocol == "tcp"
    error_message = "Expected standard protocol to be tcp."
  }

  assert {
    condition     = length(aws_security_group_rule.main_ingress[0].cidr_blocks) == 1
    error_message = "Expected one cidr block."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[0].cidr_blocks[0] == "0.0.0.0/0"
    error_message = "Expected cidr block entry to be 0.0.0.0/0."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[0].from_port == 80
    error_message = "Expected standard from port to be 80."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[0].to_port == 80
    error_message = "Expected standard to port to be 80."
  }

  assert {
    condition     = length(aws_security_group_rule.main_egress) == 1
    error_message = "Expected security group to have 1 egress rule."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[0].protocol == "tcp"
    error_message = "Expected standard protocol to be tcp."
  }

  assert {
    condition     = length(aws_security_group_rule.main_egress[0].cidr_blocks) == 1
    error_message = "Expected one cidr block."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[0].cidr_blocks[0] == "0.0.0.0/0"
    error_message = "Expected cidr block entry to be 0.0.0.0/0."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[0].from_port == 80
    error_message = "Expected standard from port to be 80."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[0].to_port == 80
    error_message = "Expected standard to port to be 80."
  }
}
