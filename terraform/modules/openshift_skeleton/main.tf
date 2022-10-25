module "network" {
  source = "../vpc_module"

  vpc_name    = var.vpc_name
  cidr        = var.cidr
  subnet_list = local.subnet_list
}
module "load_balancer" {
  source = "../load_balancer_module"

  name         = "openshift_load_balancer"
  address_type = "intranet"
  lb_spec      = "slb.s2.small"
  vswitch_id   = module.network.vsw_ids[0]
}
module "oss_bucket" {
  source = "../oss_module"

  bucket        = var.bucket
  acl           = var.acl
  storage_class = var.storage_class
}
module "nat_gateway" {
  source = "../nat_module"

  nat_name   = "openshift_nat"
  eip_name   = "openshift_eip"
  vpc_id     = module.network.vpc_id
  vswitch_id = module.network.vsw_ids[0]
}
module "dns_gateway" {
  source = "../dns_module"

  domain      = var.domain
  record_list = local.dns_record_list
}
module "nas" {
  source = "../nas_module"

  protocol     = "NFS"
  storage_type = "Capacity"
  file_system  = "standard"
  capacity     = null
  description  = "NAS for openshift"
  zone_id      = "${var.region}-a"
  vpc_id       = module.network.vpc_id
  vswitch_id   = module.network.vsw_ids[0]
}
module "openshift_ecs" {
  source = "../ecs_module"

  for_each = local.instance_list

  num_cpu               = each.value.num_cpu
  num_mem               = each.value.num_mem
  name                  = each.value.name
  vpc_id                = module.network.vpc_id
  vsw_id                = module.network.vsw_ids[0]
  enable_public_ip      = each.value.enable_public_ip
  enable_startup_script = false
  system_disk_size      = each.value.system_disk_size
  system_disk_category  = each.value.system_disk_category
  image_id              = each.value.image_id
}
module "security_group" {
  source = "../security_group_module"

  sg_name      = "openshift_security_rule"
  desc         = "ingress and egress rule for openshift instances"
  vpc_id       = module.network.vpc_id
  ingress_list = local.ingress_list
  egress_list  = local.egress_list
}
