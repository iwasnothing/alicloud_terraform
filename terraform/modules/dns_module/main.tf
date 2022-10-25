resource "alicloud_alidns_domain" "dns" {
  domain_name = var.domain
}
resource "alicloud_alidns_record" "record" {
  for_each = var.record_list

  domain_name = var.domain
  rr          = each.value.host_record
  type        = "A"
  value       = each.value.ip
  remark      = each.value.remark
  status      = "ENABLE"
}
