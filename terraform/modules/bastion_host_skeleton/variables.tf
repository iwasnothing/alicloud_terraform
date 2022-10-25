variable "num_cpu" {
  type    = number
  default = 1
}
variable "num_mem" {
  type    = number
  default = 2
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
