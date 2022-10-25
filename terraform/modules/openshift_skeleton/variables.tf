variable "num_cpu" {
  type    = number
  default = 1
}
variable "num_mem" {
  type    = number
  default = 2
}
variable "system_disk_size" {
  type    = number
  default = 200
}
variable "name" {
  type = string
}
variable "vpc_name" {
  type = string
}
variable "cidr" {
  type = string
}
variable "region" {
  type = string
}
variable "system_disk_category" {
  type    = string
  default = "cloud_ssd"
}
variable "image_id_installer" {
  type    = string
  default = "^openshift_installer"
}
variable "image_id_bootstrap" {
  type    = string
  default = "^openshift_bootstrap"
}
variable "image_id_master" {
  type    = string
  default = "^openshift_master"
}
variable "image_id_worker" {
  type    = string
  default = "^openshift_worker"
}
variable "bucket" {
  type    = string
  default = "b2-os"
}
variable "acl" {
  type    = string
  default = "private"
}
variable "storage_class" {
  type    = string
  default = "Standard"
}
variable "domain" {
  type = string
}
