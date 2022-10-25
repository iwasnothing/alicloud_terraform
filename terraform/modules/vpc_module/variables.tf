variable "vpc_name" {
  type = string
}
variable "cidr" {
  type = string
}
variable "subnet_list" {
  type = map(map(string))
}
