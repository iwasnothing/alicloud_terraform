resource "alicloud_nat_gateway" "default" {
  vpc_id = var.vpc_id
  name   = var.nat_name
}

resource "alicloud_eip_address" "default" {
  address_name = var.eip_name
}

resource "alicloud_eip_association" "default" {
  allocation_id = alicloud_eip_address.default.id
  instance_id   = alicloud_nat_gateway.default.id
}
resource "alicloud_snat_entry" "default" {
  depends_on        = [alicloud_eip_association.default]
  snat_table_id     = alicloud_nat_gateway.default.snat_table_ids
  source_vswitch_id = var.vswitch_id
  snat_ip           = alicloud_eip_address.default.ip_address
}
