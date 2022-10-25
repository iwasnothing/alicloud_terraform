resource "alicloud_ecs_command" "default" {
  count           = var.enable_startup_script ? 1 : 0
  name            = var.script_name
  command_content = var.script_base64
  description     = "For ECS startup"
  type            = "RunShellScript"
  working_dir     = "/root"
}
resource "alicloud_ecs_invocation" "default" {
  count       = var.enable_startup_script ? 1 : 0
  command_id  = alicloud_ecs_command.default[0].id
  instance_id = [alicloud_instance.default.id]
}
