import pulumi
import pulumi_alicloud as alicloud

class private_zone_module:
    def __init__(self,zone_name,vpc_id):
        self.zone_name = zone_name
        self.zone = alicloud.pvtz.Zone(zone_name, zone_name=zone_name)
        self.zone_attachment = alicloud.pvtz.ZoneAttachment(zone_name+"-attachment",
                                        zone_id=self.zone.id,
                                        vpc_ids=[vpc_id ])
        self.record_list = []
  
        pulumi.export(self.zone_name, self.zone.id)
        pulumi.export(self.zone_name+"-attachment", self.zone_attachment.id)

    def add_record(self,record,rectype,value,ttl):
        cname = self.zone_name+"-record-"+str(len(self.record_list))
        self.record_list.append( alicloud.pvtz.ZoneRecord(cname,
                                 zone_id=self.zone.id,
                                 rr=record,
                                 type=rectype,
                                 value=value,
                                 ttl=ttl))
        pulumi.export(cname, self.record_list[-1].id)
