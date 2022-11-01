import pulumi
import pulumi_alicloud as alicloud

class oss_module:
    def __init__(self,name,acl,storage_class):
        self.bucket = alicloud.oss.Bucket(name,acl=acl,storage_class=storage_class)
        pulumi.export(name, self.bucket.id)
