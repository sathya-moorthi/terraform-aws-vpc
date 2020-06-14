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
  private_subnets     = ["10.65.21.0/24", "10.65.22.0/24", "10.65.23.0/24"]
  public_subnets      = ["10.65.11.0/24", "10.65.12.0/24", "10.65.13.0/24"]
  database_subnets    = ["10.65.31.0/24", "10.65.32.0/24", "10.65.33.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "service.consul"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.65.0.2"]

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true

  tags = {
    Owner       = "user"
    Environment = "test"
    Name        = "terraform-test"
  }

  vpc_endpoint_tags = {
    Project  = "Secret"
    Endpoint = "true"
  }
}

