import pulumi
import pulumi_alicloud as alicloud

class nat_module:
    def __init__(self,name,vpc_id,vswitch_id):
        self.nat_gateway = alicloud.vpc.NatGateway(name,
                           nat_gateway_name=name,
                           vpc_id=vpc_id,
                           vswitch_id=vswitch_id)
        self.eip = alicloud.ecs.EipAddress(name+"-eip", address_name=name+"-eip",
                                               internet_charge_type="PayByTraffic", isp="BGP", payment_type="PayAsYouGo")
        self.eip_association = alicloud.ecs.EipAssociation(name+"-eip-association",allocation_id=self.eip.id,
                                               instance_id=self.nat_gateway.id,instance_type="Nat",force=False)
        self.snat = alicloud.vpc.SnatEntry(name+"-SNat",snat_entry_name=name+"-snat", snat_ip = self.eip.ip_address,
                                               snat_table_id=self.nat_gateway.snat_table_ids,
                                               source_vswitch_id=vswitch_id)
     
        pulumi.export(name, self.nat_gateway.id)
        pulumi.export(name+"-eip", self.eip.id)
        pulumi.export(name+"-eip-association", self.eip_association.id)
        pulumi.export(name+"-SNat", self.snat.id)
