locals {
  region       = var.region
  project_name = var.project_name
  environment  = var.environment
}

# create vpc module
module "vpc" {
  source       = "../../modules/vpc"
  region       = local.region
  project_name = local.project_name
  environment  = local.environment

  # vpc ""
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
}

# create nat-gateways
module "nat_gateway" {
  source       = "../../modules/nat-gateway"
  project_name = local.project_name
  environment  = local.environment

  vpc_id                     = module.vpc.vpc_id
  internet_gateway           = module.vpc.internet_gateway
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
}

#create security groups
module "security_group" {
  source = "../../modules/security-group"

  project_name = local.project_name
  environment  = local.environment

  vpc_id = module.vpc.vpc_id
  ssh_ip = var.ssh_id
}

#create security groups
# module "rds" {
#   source = "../../modules/rds"
#
#   # nat-gateway ""s
#
#   project_name = local.project_name
#   environment = local.environment
#   private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
#   private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id
#   database_snapshot_identifier = var.database_snapshot_identifier
#   database_instance_class = var.database_instance_class
#   availability_zone_1 = module.vpc.availability_zone_1
#   database_instance_identifier = var.database_instance_identifier
#   multi_az_deployment = var.multi_az_deployment
#   database_security_group_id = module.security_group.database_security_group_id
# }

# request ssl certificate
# module "ssl_certificate" {
#   source = "../../modules/acm"
#
#   domain_name       = var.domain_name
#   alternative_names = var.alternative_names
#
# }
