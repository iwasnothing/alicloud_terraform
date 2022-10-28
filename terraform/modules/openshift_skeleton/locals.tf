locals {
  domain = "${var.app_name}-${var.env}-${var.org_name}"
  subnet_list = {
    shared_zone = {
      cidr = var.cidr
      zone = "${var.region}-a"
    }
  }
  subnet_ip_mask     = split("/", var.cidr)
  subnet_octet       = split(".", local.subnet_ip_mask[0])
  ip_octet_openshift = 1
  ip_octet_start     = 16
  ip_octet_master    = range(local.ip_octet_start, local.ip_octet_start+var.num_master)
  ip_octet_worker    = range(local.ip_octet_start + var.num_master, local.ip_octet_start+var.num_master+var.num_worker)
  ip_octet_bootstrap = local.ip_octet_start + var.num_master + var.num_worker
  ip_octet_installer = local.ip_octet_bootstrap + 1
  ip_octet_api       = local.ip_octet_bootstrap + 3

  ip_bootstrap   = join(".", tolist([for x in concat(slice(local.subnet_octet, 0, 2), tolist([local.ip_octet_openshift, local.ip_octet_bootstrap])) : tostring(x)]))
  ip_installer   = join(".", tolist([for x in concat(slice(local.subnet_octet, 0, 2), tolist([local.ip_octet_openshift, local.ip_octet_installer])) : tostring(x)]))
  ip_api         = join(".", tolist([for x in concat(slice(local.subnet_octet, 0, 2), tolist([local.ip_octet_openshift, local.ip_octet_api])) : tostring(x)]))
  ip_list_master = tolist([for i in local.ip_octet_master : join(".", tolist([for x in concat(slice(local.subnet_octet, 0, 2), tolist([local.ip_octet_openshift, i])) : tostring(x)]))])
  ip_list_worker = tolist([for i in local.ip_octet_worker : join(".", tolist([for x in concat(slice(local.subnet_octet, 0, 2), tolist([local.ip_octet_openshift, i])) : tostring(x)]))])
  server_ids_master_worker = concat(module.openshift_master.*.instance_id, module.openshift_worker.*.instance_id)
  server_ids_master_worker_boostrap = var.enable_bootstrap ? concat([module.openshift_bootstrap[0].instance_id], local.server_ids_master_worker) : local.server_ids_master_worker
  server_ids_master_worker_boostrap_installer = var.enable_installer ? concat([module.openshift_installer[0].instance_id] , local.server_ids_master_worker_boostrap) : local.server_ids_master_worker_boostrap
  api_rr       = join(".", tolist([for x in [local.ip_octet_api, local.ip_octet_openshift] : tostring(x)]))
  bootstrap_rr = join(".", tolist([for x in [local.ip_octet_bootstrap, local.ip_octet_openshift] : tostring(x)]))
  master_rr    = tolist([for i in local.ip_octet_master : join(".", tolist([for x in [i, local.ip_octet_openshift] : tostring(x)]))])
  worker_rr    = tolist([for i in local.ip_octet_worker : join(".", tolist([for x in [i, local.ip_octet_openshift] : tostring(x)]))])

  pvtz_zone = join(".", tolist([tostring(local.subnet_octet[1]), tostring(local.subnet_octet[0]), "in-addr", "arpa"]))
  ttl       = 60

  num_listener   = 5
  backend_ports  = [6443, 443, 80, 22623, 22]
  frontend_ports = [6443, 443, 80, 22623, 22]

  ingress_list = {
    http = {
      enable_internet        = true
      protocol               = "tcp"
      port_range             = "80/80"
      description            = "http"
      enable_target_cidr     = true
      target_cidr            = var.cidr
      enable_target_group_id = false
      enable_target_account  = false
    }
    https = {
      enable_internet        = true
      protocol               = "tcp"
      port_range             = "443/443"
      description            = "https"
      enable_target_cidr     = true
      target_cidr            = var.cidr
      enable_target_group_id = false
      enable_target_account  = false
    }
    ssh = {
      enable_internet        = true
      protocol               = "tcp"
      port_range             = "22/22"
      description            = "ssh"
      enable_target_cidr     = true
      target_cidr            = var.cidr
      enable_target_group_id = false
      enable_target_account  = false
    }
    host_level = {
      enable_internet        = false
      protocol               = "tcp"
      port_range             = "9000/9999"
      description            = "host level"
      enable_target_cidr     = true
      target_cidr            = var.cidr
      enable_target_group_id = false
      enable_target_account  = false
    }
    kubernetes = {
      enable_internet        = false
      protocol               = "tcp"
      port_range             = "10250/10259"
      description            = "kubernetes"
      enable_target_cidr     = true
      target_cidr            = var.cidr
      enable_target_group_id = false
      enable_target_account  = false
    }
    sdn = {
      enable_internet        = false
      protocol               = "tcp"
      port_range             = "10256/10256"
      description            = "sdn"
      enable_target_cidr     = true
      target_cidr            = var.cidr
      enable_target_group_id = false
      enable_target_account  = false
    }
    vxlan0 = {
      enable_internet        = false
      protocol               = "udp"
      port_range             = "4789/4789"
      description            = "vxlan"
      enable_target_cidr     = true
      target_cidr            = var.cidr
      enable_target_group_id = false
      enable_target_account  = false
    }
    vxlan1 = {
      enable_internet        = false
      protocol               = "udp"
      port_range             = "6081/6081"
      description            = "vxlan"
      enable_target_cidr     = true
      target_cidr            = var.cidr
      enable_target_group_id = false
      enable_target_account  = false
    }
    node_exporter = {
      enable_internet        = false
      protocol               = "udp"
      port_range             = "9000/9999"
      description            = "node exporter"
      enable_target_cidr     = true
      target_cidr            = var.cidr
      enable_target_group_id = false
      enable_target_account  = false
    }
    k8s_node_port_tcp = {
      enable_internet        = false
      protocol               = "tcp"
      port_range             = "30000/32767"
      description            = "k8s node port"
      enable_target_cidr     = true
      target_cidr            = var.cidr
      enable_target_group_id = false
      enable_target_account  = false
    }
    k8s_node_port_udp = {
      enable_internet        = false
      protocol               = "udp"
      port_range             = "30000/32767"
      description            = "k8s node port"
      enable_target_cidr     = true
      target_cidr            = var.cidr
      enable_target_group_id = false
      enable_target_account  = false
    }
    icmp = {
      enable_internet        = false
      protocol               = "icmp"
      port_range             = "-1/-1"
      description            = "icmp"
      enable_target_cidr     = true
      target_cidr            = var.cidr
      enable_target_group_id = false
      enable_target_account  = false
    }
    etcd = {
      enable_internet        = false
      protocol               = "tcp"
      port_range             = "2379/2380"
      description            = "etcd"
      enable_target_cidr     = true
      target_cidr            = var.cidr
      enable_target_group_id = false
      enable_target_account  = false
    }
    api = {
      enable_internet        = false
      protocol               = "tcp"
      port_range             = "6443/6443"
      description            = "api"
      enable_target_cidr     = true
      target_cidr            = var.cidr
      enable_target_group_id = false
      enable_target_account  = false
    }
    custom = {
      enable_internet        = false
      protocol               = "tcp"
      port_range             = "22623/22623"
      description            = "custom"
      enable_target_cidr     = true
      target_cidr            = var.cidr
      enable_target_group_id = false
      enable_target_account  = false
    }
  }
  egress_list = {
    allow_all = {
      enable_internet        = true
      protocol               = "tcp"
      port_range             = "1/65535"
      description            = "allow_all"
      enable_target_cidr     = true
      target_cidr            = var.cidr
      enable_target_group_id = false
      enable_target_account  = false
    }
  }
}
