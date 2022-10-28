module "network" {
  source = "../vpc_module"

  vpc_name    = var.vpc_name
  cidr        = var.cidr
  subnet_list = local.subnet_list
}
module "load_balancer" {
  source = "../load_balancer_module"

  name           = "${var.app_name}_load_balancer"
  address_type   = "intranet"
  address        = local.ip_api
  lb_spec        = var.lb_spec
  vswitch_id     = module.network.vsw_ids[0]
  scheduler      = "sch"
  protocol       = "tcp"
  bandwidth      = 10
  num_listener   = local.num_listener
  backend_ports  = local.backend_ports
  frontend_ports = local.frontend_ports
  server_ids     = local.server_ids_master_worker_boostrap_installer
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
module "openshift_installer" {
  source = "../ecs_module"

  count                 = var.enable_installer ? 1 : 0
  num_cpu               = var.num_cpu
  num_mem               = var.num_mem
  name                  = "${var.app_name}-installer-${var.env}"
  vpc_id                = module.network.vpc_id
  vsw_id                = module.network.vsw_ids[0]
  enable_public_ip      = true
  enable_elastic_ip     = false
  enable_static_ip      = true
  ip_address            = local.ip_installer
  enable_startup_script = false
  system_disk_size      = var.system_disk_size
  system_disk_category  = var.system_disk_category
  image_id              = var.image_id_installer
}
module "openshift_bootstrap" {
  source = "../ecs_module"

  count                 = var.enable_bootstrap ? 1 : 0
  num_cpu               = var.num_cpu
  num_mem               = var.num_mem
  name                  = "${var.app_name}-bootstrap-${var.env}"
  vpc_id                = module.network.vpc_id
  vsw_id                = module.network.vsw_ids[0]
  enable_public_ip      = false
  enable_elastic_ip     = false
  enable_static_ip      = true
  ip_address            = local.ip_bootstrap
  enable_startup_script = false
  system_disk_size      = var.system_disk_size
  system_disk_category  = var.system_disk_category
  image_id              = var.image_id_bootstrap
}
module "openshift_master" {
  source = "../ecs_module"

  count                 = var.num_master
  num_cpu               = var.num_cpu
  num_mem               = var.num_mem
  name                  = "${var.app_name}-master${count.index}-${var.env}"
  vpc_id                = module.network.vpc_id
  vsw_id                = module.network.vsw_ids[0]
  enable_public_ip      = false
  enable_elastic_ip     = false
  enable_static_ip      = true
  ip_address            = local.ip_list_master[count.index]
  enable_startup_script = false
  system_disk_size      = var.system_disk_size
  system_disk_category  = var.system_disk_category
  image_id              = var.image_id_master
}
module "openshift_worker" {
  source = "../ecs_module"

  count                 = var.num_worker
  num_cpu               = var.num_cpu
  num_mem               = var.num_mem
  name                  = "${var.app_name}-worker${count.index}-${var.env}"
  vpc_id                = module.network.vpc_id
  vsw_id                = module.network.vsw_ids[0]
  enable_public_ip      = false
  enable_elastic_ip     = false
  enable_static_ip      = true
  ip_address            = local.ip_list_worker[count.index]
  enable_startup_script = false
  system_disk_size      = var.system_disk_size
  system_disk_category  = var.system_disk_category
  image_id              = var.image_id_worker
}
module "security_group" {
  source = "../security_group_module"

  sg_name      = "openshift_security_rule"
  desc         = "ingress and egress rule for openshift instances"
  vpc_id       = module.network.vpc_id
  ingress_list = local.ingress_list
  egress_list  = local.egress_list
}
resource "alicloud_alidns_domain" "dns" {
  domain_name = local.domain
}
resource "alicloud_alidns_record" "apps" {
  domain_name = local.domain
  rr          = "*.apps"
  type        = "A"
  value       = local.ip_api
  remark      = "openshift apps"
  status      = "ENABLE"
}
resource "alicloud_alidns_record" "api" {
  domain_name = local.domain
  rr          = "api"
  type        = "A"
  value       = local.ip_api
  remark      = "openshift api"
  status      = "ENABLE"
}
resource "alicloud_alidns_record" "api_init" {
  domain_name = local.domain
  rr          = "api-init"
  type        = "A"
  value       = local.ip_api
  remark      = "openshift api-init"
  status      = "ENABLE"
}
resource "alicloud_alidns_record" "bootstrap" {
  domain_name = local.domain
  rr          = "bootstrap"
  type        = "A"
  value       = local.ip_bootstrap
  remark      = "openshift bootstrap"
  status      = "ENABLE"
}
resource "alicloud_alidns_record" "master" {
  count       = var.num_master
  domain_name = local.domain
  rr          = "master${count.index}"
  type        = "A"
  value       = local.ip_list_master[count.index]
  remark      = "openshift bootstrap"
  status      = "ENABLE"
}
resource "alicloud_alidns_record" "worker" {
  count       = var.num_worker
  domain_name = local.domain
  rr          = "worker${count.index}"
  type        = "A"
  value       = local.ip_list_worker[count.index]
  remark      = "openshift bootstrap"
  status      = "ENABLE"
}
resource "alicloud_pvtz_zone" "zone" {
  zone_name = local.pvtz_zone
}
resource "alicloud_pvtz_zone_attachment" "zone-attachment" {
  zone_id = alicloud_pvtz_zone.zone.id
  vpc_ids = [module.network.vpc_id]
}
resource "alicloud_pvtz_zone_record" "api" {
  zone_id = alicloud_pvtz_zone.zone.id
  rr      = local.api_rr
  type    = "PTR"
  value   = "api.${local.domain}"
  ttl     = local.ttl
}
resource "alicloud_pvtz_zone_record" "api_init" {
  zone_id = alicloud_pvtz_zone.zone.id
  rr      = local.api_rr
  type    = "PTR"
  value   = "api-init.${local.domain}"
  ttl     = local.ttl
}
resource "alicloud_pvtz_zone_record" "bootstrap" {
  zone_id = alicloud_pvtz_zone.zone.id
  rr      = local.bootstrap_rr
  type    = "PTR"
  value   = "bootstrap.${local.domain}"
  ttl     = local.ttl
}
resource "alicloud_pvtz_zone_record" "master" {
  count   = var.num_master
  zone_id = alicloud_pvtz_zone.zone.id
  rr      = local.master_rr[count.index]
  type    = "PTR"
  value   = "master${count.index}.${local.domain}"
  ttl     = local.ttl
}
resource "alicloud_pvtz_zone_record" "worker" {
  count   = var.num_worker
  zone_id = alicloud_pvtz_zone.zone.id
  rr      = local.worker_rr[count.index]
  type    = "PTR"
  value   = "worker${count.index}.${local.domain}"
  ttl     = local.ttl
}
