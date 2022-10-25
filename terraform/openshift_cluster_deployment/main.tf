module "openshift_cluster" {
  source = "../modules/openshift_skeleton"

  num_cpu              = var.num_cpu
  num_mem              = var.num_mem
  system_disk_size     = var.system_disk_size
  name                 = var.name
  domain               = var.domain
  vpc_name             = var.vpc_name
  cidr                 = var.cidr
  region               = var.region
  image_id_installer   = var.image_id_installer
  image_id_bootstrap   = var.image_id_bootstrap
  image_id_master      = var.image_id_master
  image_id_worker      = var.image_id_worker
  bucket               = var.bucket
  acl                  = "private"
  storage_class        = "Standard"
  system_disk_category = "cloud_ssd"
}
