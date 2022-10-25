resource "alicloud_nas_file_system" "default" {
  protocol_type    = var.protocol
  storage_type     = var.storage_type
  file_system_type = var.file_system
  capacity         = var.capacity
  description      = var.description
  zone_id          = var.zone_id
  vpc_id           = var.vpc_id
  vswitch_id       = var.vswitch_id
}
