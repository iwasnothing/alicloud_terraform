module "openshift_cluster" {
  source = "../modules/openshift_skeleton"

  num_cpu              = var.num_cpu
  num_mem              = var.num_mem
  system_disk_size     = var.system_disk_size
  app_name             = var.app_name
  vpc_name             = var.vpc_name
  cidr                 = var.cidr
  region               = var.region
  org_name             = var.org_name
  env                  = var.env
  lb_spec              = var.lb_spec
  num_master           = var.num_master
  num_worker           = var.num_worker
  image_id_installer   = var.image_id_installer
  image_id_bootstrap   = var.image_id_bootstrap
  image_id_master      = var.image_id_master
  image_id_worker      = var.image_id_worker
  bucket               = var.bucket
  enable_bootstrap     = var.enable_bootstrap
  enable_installer     = var.enable_installer
  acl                  = "private"
  storage_class        = "Standard"
  system_disk_category = "cloud_ssd"
}
