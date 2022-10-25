variable "name" {
  type    = string
  default = "load_balancer"
}
variable "address_type" {
  type    = string
  default = "intranet"
}
variable "lb_spec" {
  type    = string
  default = "slb.s2.small"
}
variable "vswitch_id" {
  type = string
}
