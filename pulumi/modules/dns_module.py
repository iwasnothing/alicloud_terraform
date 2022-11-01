import pulumi
import pulumi_alicloud as alicloud

class dns_module:
  def __init__(self,domain):
    self.dns = alicloud.dns.DnsDomain(domain+"_dns", domain_name=domain)
    self.record_list = []
    pulumi.export(domain+"_dns", self.dns.id)

  def add_record(self,host,rectype,value):
    idx=len(self.record_list)
    self.record_list.append(alicloud.dns.Record("record"+str(idx),
    host_record=host,
    type=rectype,
    value=value))
    pulumi.export("record"+str(idx),self.record_list[-1].id)
