resource "alicloud_slb_load_balancer" "default" {
  load_balancer_name = var.name
  address_type       = var.address_type
  address            = var.address
  load_balancer_spec = var.lb_spec
  vswitch_id         = var.vswitch_id
}
resource "alicloud_slb_server_group" "default" {
  count            = var.num_listener
  load_balancer_id = alicloud_slb_load_balancer.default.id
  name             = "${var.name}-tostring(var.frontend_ports[count.index])"
}
resource "alicloud_slb_listener" "default" {
  count            = var.num_listener
  load_balancer_id = alicloud_slb_load_balancer.default.id
  backend_port     = var.backend_ports[count.index]
  frontend_port    = var.frontend_ports[count.index]
  protocol         = var.protocol
  bandwidth        = var.bandwidth
  scheduler        = var.scheduler
  server_group_id  = alicloud_slb_server_group.default[count.index].id
}

module "server_farm" {
  source = "../server_group_module"
  count  = var.num_listener

  server_group_id = alicloud_slb_server_group.default[count.index].id
  num_instance    = length(var.server_ids)
  server_ids      = var.server_ids
  backend_port    = var.backend_ports[count.index]
}
