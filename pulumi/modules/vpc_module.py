import pulumi
import pulumi_alicloud as alicloud

class vpc_module:
    def __init__(self,vpc_name,cidr):
        self.vpc_name = vpc_name
        self.cidr = cidr
        self.vswitch_list = []

        self.vpc = alicloud.vpc.Network(self.vpc_name,cidr_block=self.cidr)
        
        pulumi.export(self.vpc_name, self.vpc.id)

    def add_vswitch(self,vswitch_name,cidr,zone_id):
        self.vswitch_list.append(
                          alicloud.vpc.Switch(vswitch_name,zone_id=zone_id,cidr_block=cidr,vpc_id=self.vpc.id)
                          )
        pulumi.export(vswitch_name, self.vswitch_list[-1].id)
