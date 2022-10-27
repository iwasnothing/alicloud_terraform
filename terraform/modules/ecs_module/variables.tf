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
  default = 30
}
variable "name" {
  type = string
}
variable "image_id" {
  type = string
}
variable "system_disk_category" {
  type    = string
  default = "cloud_efficiency"
}
variable "vpc_id" {
  type = string
}
variable "security_groups_ids" {
  type    = list(any)
  default = []
}
variable "vsw_id" {
  type = string
}
variable "script_name" {
  type    = string
  default = ""
}
variable "script_base64" {
  type    = string
  default = ""
}
variable "enable_startup_script" {
  type    = bool
  default = false
}
variable "enable_public_ip" {
  type    = bool
  default = false
}
variable "enable_static_ip" {
  type    = bool
  default = false
}
variable "enable_elastic_ip" {
  type    = bool
  default = false
}
variable "ip_address" {
  type    = string
  default = ""
}
variable "internet_bandwidth" {
  type    = number
  default = 10
}
