output "instance_id" {
  value = alicloud_instance.default.id
}
output "public_ip" {
  value = var.enable_public_ip ? alicloud_eip_address.eip[0].ip_address : ""
}
