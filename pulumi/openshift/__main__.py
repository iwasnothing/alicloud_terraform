"""An AliCloud Python Pulumi program"""

import pulumi
import pulumi_alicloud as alicloud
from pulumi_alicloud import oss
import sys
import os
sys.path.append("../modules")

from openshift_skeleton import openshift_skeleton


config = pulumi.Config()
data = config.require_object("data")
zone = data.get("region") +"-a"

app_name=data.get("app_name")
env=data.get("env")
org_name=data.get("org_name")
cidr=data.get("cidr")
num_master=data.get("num_master")
num_worker=data.get("num_worker")
enable_installer=data.get("enable_installer")
enable_bootstrap=data.get("enable_bootstrap")
image_id_installer=data.get("image_id_installer")
image_id_bootstrap=data.get("image_id_bootstrap")
image_id_master=data.get("image_id_master")
image_id_worker=data.get("image_id_worker")
instance_type=data.get("instance_type")
system_disk_category=data.get("system_disk_category")
system_disk_size=data.get("system_disk_size")
lb_spec=data.get("lb_spec")

os = openshift_skeleton( app_name,env,org_name,cidr,zone,
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
        )

