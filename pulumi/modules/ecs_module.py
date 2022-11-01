import pulumi
import pulumi_alicloud as alicloud
from pulumi_alicloud import ecs

class ecs_module:
    def __init__(self,
            name,
            image_id,
            instance_type,
            vpc_id,
            vswitch_id, 
            zone_id,
            security_group_id,
            private_ip=None,
            allocate_public_ip=False,
            system_disk_category=None,
            system_disk_size=10
        ):
        if allocate_public_ip:
            self.internet_max_bandwidth_out = 10
        else:
            self.internet_max_bandwidth_out = 0
        self.zone_id = zone_id
        self.host_name = name
        self.instance_name = name
        self.image_id = image_id
        self.instance_type = instance_type  #e.g. ecs.xn4.small
        self.internet_charge_type = "PayByBandwidth"
        self.private_ip = private_ip
        self.vpc_id = vpc_id
        self.vswitch_id = vswitch_id
        self.security_group_id = security_group_id
        self.system_disk_category = system_disk_category
        self.system_disk_size = system_disk_size
        self.opts=pulumi.ResourceOptions(protect=False)
        self.instance = ecs.Instance(self.instance_name,
            internet_max_bandwidth_out = self.internet_max_bandwidth_out,
            availability_zone = self.zone_id,
            host_name = self.host_name,
	    instance_name = self.instance_name,
            image_id = self.image_id,
            instance_type = self.instance_type,
            security_groups = [self.security_group_id],
            internet_charge_type = self.internet_charge_type,
            private_ip = self.private_ip,
            vswitch_id = self.vswitch_id,
            system_disk_category = self.system_disk_category,
            system_disk_size = self.system_disk_size)
            
        pulumi.export(self.instance_name, self.instance.id)
