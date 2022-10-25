output "vpc_id" {
  value = alicloud_vpc.vpc.id
}
output "vsw_ids" {
  value = [for s in alicloud_vswitch.vsw: s.id]
}
