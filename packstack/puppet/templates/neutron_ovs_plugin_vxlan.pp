
class { 'neutron::plugins::ovs':
  tenant_network_type => hiera('CONFIG_NEUTRON_OVS_TENANT_NETWORK_TYPE'),
  network_vlan_ranges => hiera('CONFIG_NEUTRON_OVS_VLAN_RANGES'),
  tunnel_id_ranges    => hiera('CONFIG_NEUTRON_OVS_TUNNEL_RANGES'),
  vxlan_udp_port      => hiera('CONFIG_NEUTRON_OVS_VXLAN_UDP_PORT'),
}
