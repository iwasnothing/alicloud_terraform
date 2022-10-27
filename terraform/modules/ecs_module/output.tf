output "instance_id" {
  value = alicloud_instance.default.id
}
output "elastic_ip" {
  value = var.enable_elastic_ip ? alicloud_eip_address.eip[0].ip_address : ""
}
output "public_ip" {
  value = var.enable_public_ip ? alicloud_instance.default.public_ip : ""
}
