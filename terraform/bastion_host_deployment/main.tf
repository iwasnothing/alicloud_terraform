module "bastion_host" {
  source = "../modules/bastion_host_skeleton"

  num_cpu  = var.num_cpu
  num_mem  = var.num_mem
  name     = var.name
  vpc_name = var.vpc_name
  cidr     = var.cidr
  region   = var.region
}
