resource "alicloud_slb_load_balancer" "default" {
  load_balancer_name = var.name
  address_type       = var.address_type
  load_balancer_spec = var.lb_spec
  vswitch_id         = var.vswitch_id
}
