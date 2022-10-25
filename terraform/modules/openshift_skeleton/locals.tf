locals {
  subnet_list = {
    shared_zone = {
      cidr = var.cidr
      zone = "${var.region}-a"
    }
  }
  instance_list = {
    installer = {
      name                 = "installer"
      num_cpu              = var.num_cpu
      num_mem              = var.num_mem
      system_disk_size     = var.system_disk_size
      system_disk_category = var.system_disk_category
      image_id             = var.image_id_installer
      enable_public_ip     = true
    }
    bootstrap = {
      name                 = "bootstrap"
      num_cpu              = var.num_cpu
      num_mem              = var.num_mem
      system_disk_size     = var.system_disk_size
      system_disk_category = var.system_disk_category
      image_id             = var.image_id_bootstrap
      enable_public_ip     = true
    }
    master0 = {
      name                 = "master0"
      num_cpu              = var.num_cpu
      num_mem              = var.num_mem
      system_disk_size     = var.system_disk_size
      system_disk_category = var.system_disk_category
      image_id             = var.image_id_master
      enable_public_ip     = false
    }
    master1 = {
      name                 = "master1"
      num_cpu              = var.num_cpu
      num_mem              = var.num_mem
      system_disk_size     = var.system_disk_size
      system_disk_category = var.system_disk_category
      image_id             = var.image_id_master
      enable_public_ip     = false
    }
    master2 = {
      name                 = "master2"
      num_cpu              = var.num_cpu
      num_mem              = var.num_mem
      system_disk_size     = var.system_disk_size
      system_disk_category = var.system_disk_category
      image_id             = var.image_id_master
      enable_public_ip     = false
    }
    worker0 = {
      name                 = "worker0"
      num_cpu              = var.num_cpu
      num_mem              = var.num_mem
      system_disk_size     = var.system_disk_size
      system_disk_category = var.system_disk_category
      image_id             = var.image_id_worker
      enable_public_ip     = false
    }
    worker1 = {
      name                 = "worker1"
      num_cpu              = var.num_cpu
      num_mem              = var.num_mem
      system_disk_size     = var.system_disk_size
      system_disk_category = var.system_disk_category
      image_id             = var.image_id_worker
      enable_public_ip     = false
    }
    worker2 = {
      name                 = "worker2"
      num_cpu              = var.num_cpu
      num_mem              = var.num_mem
      system_disk_size     = var.system_disk_size
      system_disk_category = var.system_disk_category
      image_id             = var.image_id_worker
      enable_public_ip     = false
    }
  }
  dns_record_list = {
    entry0 = {
      host_record = ""
      remark      = ""
      ip          = ""
    }
  }
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
