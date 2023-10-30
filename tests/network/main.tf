resource "aws_default_vpc" "default" {}

resource "aws_default_security_group" "default" {
  vpc_id = aws_default_vpc.default.id
}

resource "aws_ec2_managed_prefix_list" "main" {
  name           = "TestPrefixList"
  address_family = "IPv4"
  max_entries    = 5

  entry {
    cidr        = aws_default_vpc.default.cidr_block
    description = "Primary"
  }
}
