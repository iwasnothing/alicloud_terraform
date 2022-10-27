variable "server_group_id" {
  type    = string
}
variable "num_instance" {
  type    = number
  default = 1
}
variable "server_ids" {
  type = list(any)
}
variable "backend_port" {
  type = number
}
