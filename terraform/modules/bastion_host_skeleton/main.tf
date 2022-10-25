locals {
  subnet_list = {
    shared_zone = {
      cidr = var.cidr
      zone = "${var.region}-a"
    }
  }
}
module "network" {
  source = "../vpc_module"

  vpc_name    = var.vpc_name
  cidr        = var.cidr
  subnet_list = local.subnet_list
}
module "bastion_ecs" {
  source = "../ecs_module"

  num_cpu               = var.num_cpu
  num_mem               = var.num_mem
  name                  = var.name
  vpc_id                = module.network.vpc_id
  vsw_id                = module.network.vsw_ids[0]
  enable_public_ip      = true
  enable_startup_script = true
  script_name           = "install_ansible.sh"
  script_base64         = filebase64("${path.module}/install_ansible.sh")
}
