variable "sg_name" {
  type = string
}
variable "desc" {
  type    = string
  default = "default"
}
variable "vpc_id" {
  type = string
}
variable "ingress_list" {
  type = map(any)
}
variable "egress_list" {
  type = map(any)
}
