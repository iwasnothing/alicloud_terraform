resource "alicloud_image_import" "this" {
  description  = var.name
  architecture = var.arch
  image_name   = var.name
  license_type = "Auto"
  platform     = var.platform
  os_type      = "linux"
  disk_device_mapping {
    disk_image_size = var.size
    oss_bucket      = var.bucket
    oss_object      = var.file
  }
}
