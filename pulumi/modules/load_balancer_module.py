import pulumi
import pulumi_alicloud as alicloud
from pulumi_alicloud import slb


class load_balancer_module:
    def __init__(self,name,address_type,address,lb_spec,vswitch_id,bandwidth):
        self.name = name
        self.address_type = address_type
        self.address = address
        self.lb_spec = lb_spec
        self.vswitch_id = vswitch_id
        self.bandwidth = bandwidth

        self.load_balancer = slb.ApplicationLoadBalancer(self.name,
                                              address_type=self.address_type,
                                              address=self.address,
                                              bandwidth=self.bandwidth,
                                              load_balancer_name=self.name,
                                              load_balancer_spec=self.lb_spec,
                                              vswitch_id=self.vswitch_id)
        self.server_group = {}
        self.server_list = {}
        self.listener_list = {}
        pulumi.export(name, self.load_balancer.id)

    def add_listener(self,frontend_port,backend_port,protocol,scheduler):
        key_str = str(frontend_port)+"-"+str(backend_port)
        self.listener_list[key_str] = slb.Listener(self.name+"-listener-"+key_str,
                                  load_balancer_id=self.load_balancer.id,
                                  backend_port=backend_port,
                                  frontend_port=frontend_port,
                                  protocol=protocol,
                                  bandwidth=self.bandwidth,
                                  scheduler=scheduler,
                                  server_group_id=self.server_group[str(backend_port)].id)
        pulumi.export(self.name+"-listener-"+key_str, self.listener_list[key_str].id)

        
    def add_server_group(self,backend_port):
        key_str=str(backend_port)
        self.server_group[key_str] = slb.ServerGroup(self.name+"-svr-grp-"+key_str,load_balancer_id=self.load_balancer.id,name=self.name+key_str)
        self.server_list[key_str] = []
        pulumi.export(self.name+"-svr-grp-"+key_str, self.server_group[key_str].id)

    def add_server(self,server_id,backend_port):
        key_str=str(backend_port)
        idx = len(self.server_list[key_str])
        self.server_list[key_str].append(slb.ServerGroupServerAttachment(self.name+"-port-"+key_str+"-server"+str(idx),
                                server_group_id=self.server_group[key_str].id,
                                server_id=server_id,
                                port=backend_port))
        pulumi.export(self.name+"-port-"+key_str, self.server_list[key_str][-1].id)
