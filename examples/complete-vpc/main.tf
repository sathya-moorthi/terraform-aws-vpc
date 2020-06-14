provider "aws" {
  region = "ap-southeast-1"
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "../../"

  name = "vpc-test-01"

  cidr = "10.65.0.0/16" # 10.0.0.0/8 is reserved for EC2-Classic

  azs                 = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  app_subnets         = ["10.65.21.0/24", "10.65.22.0/24", "10.65.23.0/24"]
  public_subnets      = ["10.65.11.0/24", "10.65.12.0/24", "10.65.13.0/24"]
  database_subnets    = ["10.65.31.0/24", "10.65.32.0/24", "10.65.33.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "service.consul"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.65.0.2"]

  # VPC endpoint for S3
  enable_s3_endpoint = true

 # VPC endpoint for SSM
  enable_ssm_endpoint              = true
  ssm_endpoint_private_dns_enabled = true
  ssm_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for SSMMESSAGES
  enable_ssmmessages_endpoint              = true
  ssmmessages_endpoint_private_dns_enabled = true
  ssmmessages_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC Endpoint for EC2
  enable_ec2_endpoint              = true
  ec2_endpoint_private_dns_enabled = true
  ec2_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC Endpoint for EC2MESSAGES
  enable_ec2messages_endpoint              = true
  ec2messages_endpoint_private_dns_enabled = true
  ec2messages_endpoint_security_group_ids  = [data.aws_security_group.default.id]

  # VPC endpoint for KMS
  enable_kms_endpoint              = true
  kms_endpoint_private_dns_enabled = true
  kms_endpoint_security_group_ids  = [data.aws_security_group.default.id]


  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true

  tags = {
    Owner       = "user"
    Environment = "test"
    Name        = "complete"
  }

  vpc_endpoint_tags = {
    Project  = "Secret"
    Endpoint = "true"
  }
}

