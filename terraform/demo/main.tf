# Create VPC
terraform {
  required_version = ">= 0.12.2"
}

provider "aws" {
  version = ">= 2.28.1"
  region  = var.aws_region
}

module "vpc" {
  source                  = "../modules/vpc"
  create_vpc              = var.create_vpc
  create_private_subnet   = var.create_private_subnet
  aws_vpc_name            = "${var.aws_environment}-${var.aws_vpc_name}"
  aws_vpc_cidr            = var.aws_vpc_cidr
  aws_environment         = var.aws_environment
  aws_availability_zones  = var.aws_availability_zones
  public_subnet_cidr_all  = var.public_subnet_cidr_all
  private_subnet_cidr_all = var.private_subnet_cidr_all
  tags = {
    Environment = var.aws_environment
    Region      = var.aws_region
  }

  public_subnet_tags = {
    Type = "Public"
  }

  private_subnet_tags = {
    Type = "Private"
  }
}

module "defaultSecGroup_Public" {
  source = "../modules/security-groups"

  count                  = var.create_security_groups ? 1 : 0
  sec_groups_name        = "initial-garden-DefaultSecurityGroup-Public"
  sec_groups_description = "Default Security Group with Public Access"
  vpc_id                 = module.vpc.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete
  ingress_rules          = var.default_secgroups_public_ingress_rules
  ingress_cidr_blocks    = var.default_secgroups_public_ingress_cidr_blocks
  egress_rules           = var.default_secgroups_public_egress_rules
  egress_cidr_blocks     = var.egress_cidr_blocks
  tags = {
    Name      = "initial-garden-DefaultSecurityGroup-Public"
    ManagedBy = "Terraform"
  }
}

module "defaultSecGroup_PrivateOnly" {
  source = "../modules/security-groups"

  count                  = var.create_security_groups ? 1 : 0
  sec_groups_name        = "initial-garden-DefaultSecurityGroup-PrivateOnly"
  sec_groups_description = "Default Security Group with Private Access"
  vpc_id                 = module.vpc.vpc_id
  revoke_rules_on_delete = var.revoke_rules_on_delete
  ingress_with_self = [
    {
      from_port : "0"
      to_port : "65535"
      protocol : "-1"
      self : true
      description : "Allow all inbound access itself. Please DO NOT CHANGE MANUALLY!!"
    },
  ]
  egress_rules = var.default_secgroups_public_egress_rules
  # egress_with_self = [
  #   {
  #     from_port : "0"
  #     to_port : "65535"
  #     protocol : "-1"
  #     self : true
  #     description : "Allow outbound itself. Please DO NOT CHANGE MANUALLY!!"
  #   }
  # ]
  tags = {
    Name      = "initial-garden-DefaultSecurityGroup-Private"
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_bucket" "this" {
  bucket = var.s3_bucket_name
  acl    = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket              = aws_s3_bucket.this.id
  block_public_acls   = true
  block_public_policy = true
}