import pulumi
import pulumi_alicloud as alicloud

class nas_module:
    def __init__(self,name,vpc_id,vswitch_id,zone_id):
        self.nas = alicloud.nas.FileSystem(name, description=name+" NAS filesystem",file_system_type="standard",
                                           protocol_type="NFS", storage_type="Capacity",
                                           vpc_id=vpc_id,vswitch_id=vswitch_id,zone_id=zone_id)
        pulumi.export(name, self.nas.id)
