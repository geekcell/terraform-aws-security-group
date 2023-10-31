run "setup" {
  module {
    source = "./tests/network"
  }
}

run "advanced_security_group_with_rules" {
  variables {
    name        = "basic-security-group-2"
    description = "This is a test security group."

    vpc_id = run.setup.vpc_id
    ingress_rules = [
      # Different To/From ports
      {
        from_port   = 3306
        to_port     = 54321
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/8"]
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
      # Different To/From ports
      {
        from_port   = 3306
        to_port     = 54321
        protocol    = "tcp"
        cidr_blocks = ["10.0.0.0/8"]
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
    error_message = "Expected security group to be created."
  }

  ### Ingress rules checks
  assert {
    condition     = length(aws_security_group_rule.main_ingress) == 4
    error_message = "Expected security group to have 5 ingress rules."
  }

  ### Assert different from / to ports
  assert {
    condition     = aws_security_group_rule.main_ingress[0].protocol == "tcp"
    error_message = "Expected standard protocol to be tcp."
  }

  assert {
    condition     = length(aws_security_group_rule.main_ingress[0].cidr_blocks) == 1
    error_message = "Expected one cidr block."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[0].cidr_blocks[0] == "10.0.0.0/8"
    error_message = "Incorrect cidr block entry."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[0].from_port == 3306
    error_message = "Incorrect from port."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[0].to_port == 54321
    error_message = "Incorrect to port."
  }

  ### Assert SG instead of CIDR
  assert {
    condition     = aws_security_group_rule.main_ingress[1].protocol == "udp"
    error_message = "Incorrect protocol."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[1].cidr_blocks == null
    error_message = "Expected no cidr blocks."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[1].source_security_group_id == run.setup.security_group_id
    error_message = "Expected security group."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[1].from_port == 3306
    error_message = "Incorrect from port."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[1].to_port == 3306
    error_message = "Incorrect to port."
  }

  ### Assert self
  assert {
    condition     = aws_security_group_rule.main_ingress[2].protocol == "udp"
    error_message = "Incorrect protocol."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[2].cidr_blocks == null
    error_message = "Expected no cidr blocks."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[2].source_security_group_id == null
    error_message = "Expected no source security group."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[2].self == true
    error_message = "Expected self to be true."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[2].from_port == 3306
    error_message = "Incorrect from port."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[2].to_port == 3306
    error_message = "Incorrect to port."
  }

  ### Assert prefix list
  assert {
    condition     = aws_security_group_rule.main_ingress[3].protocol == "tcp"
    error_message = "Incorrect protocol."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[3].cidr_blocks == null
    error_message = "Expected no cidr blocks."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[3].source_security_group_id == null
    error_message = "Expected no source security group."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[3].self == false
    error_message = "Expected self to be false."
  }

  assert {
    condition     = length(aws_security_group_rule.main_ingress[3].prefix_list_ids) == 1
    error_message = "Incorrect prefix list ids."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[3].prefix_list_ids[0] == run.setup.prefix_list_id
    error_message = "Incorrect prefix list ids entry."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[3].from_port == 443
    error_message = "Incorrect from port."
  }

  assert {
    condition     = aws_security_group_rule.main_ingress[3].to_port == 443
    error_message = "Incorrect to port."
  }

  ### Egress rules checks
  assert {
    condition     = length(aws_security_group_rule.main_egress) == 4
    error_message = "Expected security group to have 5 egress rules."
  }

  ### Assert different from / to ports
  assert {
    condition     = aws_security_group_rule.main_egress[0].protocol == "tcp"
    error_message = "Expected standard protocol to be tcp."
  }

  assert {
    condition     = length(aws_security_group_rule.main_egress[0].cidr_blocks) == 1
    error_message = "Expected one cidr block."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[0].cidr_blocks[0] == "10.0.0.0/8"
    error_message = "Incorrect cidr block entry."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[0].from_port == 3306
    error_message = "Incorrect from port."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[0].to_port == 54321
    error_message = "Incorrect to port."
  }

  ### Assert SG instead of CIDR
  assert {
    condition     = aws_security_group_rule.main_egress[1].protocol == "udp"
    error_message = "Incorrect protocol."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[1].cidr_blocks == null
    error_message = "Expected no cidr blocks."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[1].source_security_group_id == run.setup.security_group_id
    error_message = "Expected security group."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[1].from_port == 3306
    error_message = "Incorrect from port."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[1].to_port == 3306
    error_message = "Incorrect to port."
  }

  ### Assert self
  assert {
    condition     = aws_security_group_rule.main_egress[2].protocol == "udp"
    error_message = "Incorrect protocol."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[2].cidr_blocks == null
    error_message = "Expected no cidr blocks."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[2].source_security_group_id == null
    error_message = "Expected no source security group."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[2].self == true
    error_message = "Expected self to be true."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[2].from_port == 3306
    error_message = "Incorrect from port."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[2].to_port == 3306
    error_message = "Incorrect to port."
  }

  ### Assert prefix list
  assert {
    condition     = aws_security_group_rule.main_egress[3].protocol == "tcp"
    error_message = "Incorrect protocol."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[3].cidr_blocks == null
    error_message = "Expected no cidr blocks."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[3].source_security_group_id == null
    error_message = "Expected no source security group."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[3].self == false
    error_message = "Expected self to be false."
  }

  assert {
    condition     = length(aws_security_group_rule.main_egress[3].prefix_list_ids) == 1
    error_message = "Incorrect prefix list ids."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[3].prefix_list_ids[0] == run.setup.prefix_list_id
    error_message = "Incorrect prefix list ids entry."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[3].from_port == 443
    error_message = "Incorrect from port."
  }

  assert {
    condition     = aws_security_group_rule.main_egress[3].to_port == 443
    error_message = "Incorrect to port."
  }
}
