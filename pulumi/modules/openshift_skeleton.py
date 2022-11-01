import pulumi
import pulumi_alicloud as alicloud
import json
import os

from ecs_module import ecs_module
from vpc_module import vpc_module
from load_balancer_module import load_balancer_module
from oss_module import oss_module
from nat_module import nat_module
from nas_module import nas_module
from security_group_module import security_group_module
from dns_module import dns_module
from private_zone_module import private_zone_module


class openshift_skeleton:
    def __init__(self,app_name,env,org_name,cidr,zone,
                      num_master,num_worker,
                      enable_installer,
                      enable_bootstrap,
                      image_id_installer,
                      image_id_bootstrap,
                      image_id_master,
                      image_id_worker,
                      instance_type,
                      system_disk_category,
                      system_disk_size,
                      lb_spec,
        ):
        package_directory = os.path.dirname(os.path.abspath(__file__))
        parms = json.load(open( os.path.join(package_directory,"openshift_skeleton_parms.json") ))
        self.app_name = app_name
        self.env = env
        self.org_name = org_name
        self.cidr = cidr
        self.zone = zone
        self.num_master = num_master
        self.num_worker = num_worker
        self.enable_installer = enable_installer
        self.enable_bootstrap = enable_bootstrap
        self.image_id_installer = image_id_installer
        self.image_id_bootstrap = image_id_bootstrap
        self.image_id_master    = image_id_master
        self.image_id_worker    = image_id_worker
        self.instance_type      = instance_type
        self.system_disk_category = system_disk_category
        self.system_disk_size     = system_disk_size
        self.backend_ports  = parms["backend_ports"]
        self.frontend_ports = parms["frontend_ports"]

        ip_subnet_mask     = self.cidr.split("/")
        ip_subnet_octet    = ip_subnet_mask[0].split(".")
        ip_octet_openshift = parms["ip_octet_openshift"]
        ip_octet_start     = parms["ip_octet_start"]
        ip_prefix          = ".".join([ip_subnet_octet[0],ip_subnet_octet[1],str(ip_octet_openshift)])+"."
        ip_octet_master    = [ip_octet_start+i for i in range(self.num_master)]
        ip_octet_worker    = [ip_octet_start+self.num_master+1 for i in range(self.num_worker)]
        ip_octet_bootstrap = ip_octet_start + self.num_master + self.num_worker
        ip_octet_installer = ip_octet_bootstrap + 1
        ip_octet_api       = ip_octet_bootstrap + 3
        self.ip_bootstrap       = ip_prefix + str(ip_octet_bootstrap)
        self.ip_installer       = ip_prefix + str(ip_octet_installer)
        self.ip_api             = ip_prefix + str(ip_octet_api)
        self.ip_list_master     = [ip_prefix + str(i) for i in ip_octet_master]
        self.ip_list_worker     = [ip_prefix + str(i) for i in ip_octet_worker]

        self.m_vpc = vpc_module(self.app_name+"-vpc",self.cidr)
        self.m_vpc.add_vswitch(self.app_name+"-vswitch",self.cidr,self.zone)
        self.vpc_id = self.m_vpc.vpc.id
        self.vswitch_id = self.m_vpc.vswitch_list[0].id

        self.sg = security_group_module(self.app_name,self.vpc_id)
        self.sg_id = self.sg.sg.id

        self.security_rules = parms["security_rules"]
        for rule in self.security_rules:
            self.sg.add_security_rule(rule["name"],rule["name"],rule["protocol"],self.cidr,rule["type"],rule["nic_type"],rule["port_range"])

        if self.enable_installer:
            self.m_installer = ecs_module(
            name=self.app_name+"-installer",
            image_id=self.image_id_installer,
            instance_type=self.instance_type,
            vpc_id = self.vpc_id,
            vswitch_id=self.vswitch_id,
            zone_id=self.zone,
            security_group_id = self.sg_id, 
            private_ip=self.ip_installer,
            allocate_public_ip=True,
            system_disk_category=self.system_disk_category,
            system_disk_size=self.system_disk_size)
        if self.enable_bootstrap:
            self.m_bootstrap = ecs_module(
            name=self.app_name+"-bootstrap",
            image_id=self.image_id_bootstrap,
            instance_type=self.instance_type,
            vpc_id = self.vpc_id,
            vswitch_id=self.vswitch_id,
            zone_id=self.zone,
            security_group_id = self.sg_id, 
            private_ip=self.ip_bootstrap,
            allocate_public_ip=False,
            system_disk_category=self.system_disk_category,
            system_disk_size=self.system_disk_size)


        self.m_master_list = []
        for i in range(self.num_master):
            self.m_master_list.append(ecs_module(
            name=self.app_name+"-master"+str(i),
            image_id=self.image_id_master,
            instance_type=self.instance_type,
            vpc_id = self.vpc_id,
            vswitch_id=self.vswitch_id,
            zone_id=self.zone,
            security_group_id = self.sg_id, 
            private_ip=self.ip_list_master[i],
            allocate_public_ip=False,
            system_disk_category=self.system_disk_category,
            system_disk_size=self.system_disk_size))

        self.m_worker_list = []
        for i in range(self.num_worker):
            self.m_worker_list.append(ecs_module(
            name=self.app_name+"-worker"+str(i),
            image_id=self.image_id_worker,
            instance_type=self.instance_type,
            vpc_id = self.vpc_id,
            vswitch_id=self.vswitch_id,
            zone_id=self.zone,
            security_group_id = self.sg_id, 
            private_ip=self.ip_list_worker[i],
            allocate_public_ip=False,
            system_disk_category=self.system_disk_category,
            system_disk_size=self.system_disk_size))


        self.load_balancer = load_balancer_module(self.app_name,"intranet",self.ip_api,lb_spec,self.vswitch_id,10)
        for p in self.backend_ports:
            self.load_balancer.add_server_group(p)
            if self.enable_installer:
                self.load_balancer.add_server(self.m_installer.instance.id,p)
            if self.enable_bootstrap:
                self.load_balancer.add_server(self.m_bootstrap.instance.id,p)
            for s in self.m_master_list:
                self.load_balancer.add_server(s.instance.id,p)
            for s in self.m_worker_list:
                self.load_balancer.add_server(s.instance.id,p)
        for i,p in enumerate(self.frontend_ports):
            frontend_port = p
            backend_port = self.backend_ports[i]
            protocol = "tcp"
            scheduler = "sch"
            self.load_balancer.add_listener(frontend_port,backend_port,protocol,scheduler)

        self.oss_bucket = oss_module(self.app_name+"-bucket","private","Standard")
        self.nat = nat_module(self.app_name+"-nat",self.vpc_id,self.vswitch_id)
        self.nas = nas_module(self.app_name+"-nas",self.vpc_id,self.vswitch_id,self.zone)

        self.domain = "-".join([self.app_name,self.env,self.org_name])
        self.dns = dns_module(self.domain)
        self.dns.add_record("*.apps","A",self.ip_api)
        self.dns.add_record("api","A",self.ip_api)
        self.dns.add_record("api-init","A",self.ip_api)
        self.dns.add_record("bootstrap","A",self.ip_bootstrap)
        for i in range(self.num_master):
            self.dns.add_record("master"+str(i),"A",self.ip_list_master[i])
        for i in range(self.num_worker):
            self.dns.add_record("worker"+str(i),"A",self.ip_list_worker[i])

        self.prtz_name = ".".join([ ip_subnet_octet[1], ip_subnet_octet[0], "in-addr", "arpa"]) 
        self.private_zone = private_zone_module(self.prtz_name,self.vpc_id)


        api_rr       = ".".join([str(ip_octet_api) , str(ip_octet_openshift) ])
        bootstrap_rr = ".".join([str(ip_octet_bootstrap) , str(ip_octet_openshift) ])
        master_rr    = [".".join([ str(i),str(ip_octet_openshift)]) for i in ip_octet_master]
        worker_rr    = [".".join([ str(i),str(ip_octet_openshift)]) for i in ip_octet_worker]

        self.private_zone.add_record(api_rr,parms["prtz_type"],"api."+self.domain,parms["ttl"])
        self.private_zone.add_record(api_rr,parms["prtz_type"],"api-init."+self.domain,parms["ttl"])
        self.private_zone.add_record(bootstrap_rr,parms["prtz_type"],"bootstrap."+self.domain,parms["ttl"])
        for i in range(self.num_master):
            self.private_zone.add_record(master_rr[i],parms["prtz_type"],"master"+str(i)+"."+self.domain,parms["ttl"])
        for i in range(self.num_worker):
            self.private_zone.add_record(worker_rr[i],parms["prtz_type"],"worker"+str(i)+"."+self.domain,parms["ttl"])
