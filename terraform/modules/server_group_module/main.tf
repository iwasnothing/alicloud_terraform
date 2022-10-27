resource "alicloud_slb_server_group_server_attachment" "default" {
  count           = var.num_instance
  server_group_id = var.server_group_id
  server_id       = var.server_ids[count.index]
  port            = var.backend_port
}

