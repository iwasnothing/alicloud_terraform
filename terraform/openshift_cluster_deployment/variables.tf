variable "num_cpu" {
  type = number
}
variable "num_mem" {
  type = number
}
variable "system_disk_size" {
  type = number
}
variable "name" {
  type = string
}
variable "domain" {
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
