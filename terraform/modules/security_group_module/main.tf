resource "alicloud_security_group" "default" {
  name        = var.sg_name
  description = var.desc
  vpc_id      = var.vpc_id
}
resource "alicloud_security_group_rule" "allow_ingress" {
  for_each                   = var.ingress_list
  type                       = "ingress"
  ip_protocol                = each.value.protocol
  nic_type                   = each.value.enable_internet ? "internet" : "intranet"
  policy                     = "accept"
  port_range                 = each.value.port_range
  priority                   = 1
  description                = each.value.description
  security_group_id          = alicloud_security_group.default.id
  cidr_ip                    = each.value.enable_target_cidr ? each.value.target_cidr : null
  source_security_group_id   = each.value.enable_target_group_id ? each.value.target_group_id : null
  source_group_owner_account = each.value.enable_target_account ? each.value.target_account : null
}
resource "alicloud_security_group_rule" "allow_egress" {
  for_each                   = var.egress_list
  type                       = "egress"
  ip_protocol                = each.value.protocol
  nic_type                   = each.value.enable_internet ? "internet" : "intranet"
  policy                     = "accept"
  port_range                 = each.value.port_range
  priority                   = 1
  description                = each.value.description
  security_group_id          = alicloud_security_group.default.id
  cidr_ip                    = each.value.enable_target_cidr ? each.value.target_cidr : null
  source_security_group_id   = each.value.enable_target_group_id ? each.value.target_group_id : null
  source_group_owner_account = each.value.enable_target_account ? each.value.target_account : null
}
