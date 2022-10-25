resource "alicloud_vpc" "vpc" {
  vpc_name   = var.vpc_name
  cidr_block = var.cidr
}
resource "alicloud_vswitch" "vsw" {
  for_each   = var.subnet_list
  vpc_id     = alicloud_vpc.vpc.id
  cidr_block = each.value.cidr
  zone_id    = each.value.zone
}
