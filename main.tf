provider "aws" {
  region = "ap-southeast-2"

  default_tags {
    tags = {
      hashicorp-learn = "module-use"
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}

module "aft_pipeline" {
  source = "aws-ia/control_tower_account_factory/aws"
  # Required Variables
  ct_management_account_id = 145306892140
  log_archive_account_id = 091833507420
  audit_account_id = 393160057906
  aft_management_account_id = 758391798493
  ct_home_region = ap-southeast-2
  tf_backend_secondary_region = ap-southeast-1
  
  # Terraform variables
  terraform_version = "0.15.5"
  terraform_distribution = "oss"
    
  # VCS variables
  vcs_provider = "github"

  # AFT Feature flags
  aft_feature_cloudtrail_data_events = false
  aft_feature_enterprise_support = false
  aft_feature_delete_default_vpcs_enabled = false
}


