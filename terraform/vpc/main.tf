module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=0.27.0"
  namespace  = var.namespace
  name       = "vpc"
  stage      = var.environment
  cidr_block = var.vpc_cidr_block
  tags = merge(var.tags, tomap({
    Name         = "${var.namespace}-${var.environment}-vpc"

  }))
}

locals {
  public_cidr_block  = cidrsubnet(module.vpc.vpc_cidr_block, 1, 0)
  private_cidr_block = cidrsubnet(module.vpc.vpc_cidr_block, 1, 1)
}

module "public_subnets" {
  source              = "git::https://github.com/cloudposse/terraform-aws-multi-az-subnets.git?ref=0.14.1"
  namespace           = var.namespace
  stage               = var.environment
  name                = "publicsubnet"
  availability_zones  = var.availability_zones
  vpc_id              = module.vpc.vpc_id
  cidr_block          = local.public_cidr_block
  type                = "public"
  igw_id              = module.vpc.igw_id
  nat_gateway_enabled = "true"
  tags = merge(var.tags, {
    "Name" = "${var.namespace}-${var.environment}-public-subnet"
  })
}

module "private_subnets" {
  source             = "git::https://github.com/cloudposse/terraform-aws-multi-az-subnets.git?ref=0.14.1"
  namespace          = var.namespace
  stage              = var.environment
  name               = "privatesubnet"
  availability_zones = var.availability_zones
  vpc_id             = module.vpc.vpc_id
  cidr_block         = local.private_cidr_block
  type               = "private"
  tags = merge(var.tags, tomap({
    "Name" = "${var.namespace}-${var.environment}-db-private-subnet"
  }))
  az_ngw_ids = module.public_subnets.az_ngw_ids
}
