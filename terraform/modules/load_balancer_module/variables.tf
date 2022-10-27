variable "name" {
  type    = string
  default = "load_balancer"
}
variable "address_type" {
  type    = string
  default = "intranet"
}
variable "address" {
  type = string
}
variable "lb_spec" {
  type    = string
  default = "slb.s1.small"
}
variable "vswitch_id" {
  type = string
}
variable "scheduler" {
  type    = string
  default = "rr"
}
variable "protocol" {
  type    = string
  default = "tcp"
}
variable "bandwidth" {
  type    = number
  default = 10
}
variable "num_listener" {
  type    = number
  default = 1
}
variable "server_ids" {
  type = list(any)
}
variable "backend_ports" {
  type = list(any)
}
variable "frontend_ports" {
  type = list(any)
}
