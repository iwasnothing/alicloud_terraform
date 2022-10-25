variable "bucket" {
  type    = string
}
variable "acl" {
  type    = string
  default = "private"
}
variable "storage_class" {
  type    = string
  default = "Standard"
}
