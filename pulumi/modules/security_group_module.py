import pulumi
import pulumi_alicloud as alicloud
from pulumi_alicloud import ecs

class security_group_module:
    def __init__(self, name,vpc_id):
        self.vpc_id = vpc_id
        self.sg = alicloud.ecs.SecurityGroup(name+"_sg",description=name+"_security_groups",vpc_id=self.vpc_id)
        self.sg_rules = []
        pulumi.export(name+"_sg", self.sg.id)            
    def add_security_rule(self,name,description,ip_protocol,cidr_ip,type,nic_type,port_range):
        self.sg_rules.append(alicloud.ecs.SecurityGroupRule(name,ip_protocol=ip_protocol,
                                                  cidr_ip=cidr_ip,
                                                  description=description,
                                                  security_group_id=self.sg.id,
                                                  type = type,
                                                  nic_type = nic_type))
        pulumi.export(name, self.sg_rules[-1].id)            
