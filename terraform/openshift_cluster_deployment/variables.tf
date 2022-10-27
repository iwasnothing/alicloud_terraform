variable "num_cpu" {
  type = number
}
variable "num_mem" {
  type = number
}
variable "num_master" {
  type = number
}
variable "num_worker" {
  type = number
}
variable "system_disk_size" {
  type = number
}
variable "app_name" {
  type    = string
  default = "openshift"
}
variable "env" {
  type = string
}
variable "org_name" {
  type = string
}
variable "vpc_name" {
  type = string
}
variable "cidr" {
  type = string
}
variable "image_id_installer" {
  type = string
}
variable "image_id_bootstrap" {
  type = string
}
variable "image_id_master" {
  type = string
}
variable "image_id_worker" {
  type = string
}
variable "bucket" {
  type = string
}
variable "lb_spec" {
  type = string
}
