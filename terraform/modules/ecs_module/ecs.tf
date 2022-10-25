data "alicloud_instance_types" "c2g4" {
  cpu_core_count = var.num_cpu
  memory_size    = var.num_mem
}

resource "alicloud_instance" "default" {
  image_id             = var.image_id
  internet_charge_type = "PayByBandwidth"

  instance_type        = data.alicloud_instance_types.c2g4.instance_types.0.id
  system_disk_category = var.system_disk_category
  system_disk_size     = var.system_disk_size
  security_groups      = var.security_groups_ids
  instance_name        = var.name
  vswitch_id           = var.vsw_id
}


resource "alicloud_eip_address" "eip" {
  count = var.enable_public_ip ? 1 : 0
}

resource "alicloud_eip_association" "eip_asso" {
  count = var.enable_public_ip ? 1 : 0

  allocation_id = alicloud_eip_address.eip[count.index].id
  instance_id   = alicloud_instance.default.id
}
