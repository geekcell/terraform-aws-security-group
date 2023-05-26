module "vpc" {
  source  = "registry.terraform.io/terraform-aws-modules/vpc/aws"
  version = "~> 3.19"

  name = "${var.name}-main"
  cidr = "10.100.0.0/16"
}

module "basic-example" {
  source = "../../"

  vpc_id      = module.vpc.vpc_id
  name        = var.name
  description = "Testing Terraform basic example"

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
}
