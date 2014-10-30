$ovs_agent_gre_cfg_neut_ovs_tun_if = hiera('CONFIG_NEUTRON_OVS_TUNNEL_IF')

if $ovs_agent_gre_cfg_neut_ovs_tun_if != '' {
  $iface = regsubst($ovs_agent_gre_cfg_neut_ovs_tun_if, '[\.\-\:]', '_', 'G')
  $localip = inline_template("<%%= scope.lookupvar('::ipaddress_${iface}') %%>")
} else {
  $localip = $cfg_neutron_ovs_host
}

if hiera('CONFIG_NEUTRON_L2_PLUGIN') == 'ml2' {
  class { 'neutron::agents::ml2::ovs':
    bridge_mappings  => hiera_array('CONFIG_NEUTRON_OVS_BRIDGE_MAPPINGS'),
    enable_tunneling => true,
    tunnel_types     => ['gre'],
    local_ip         => $localip,
    l2_population    => hiera('CONFIG_NEUTRON_USE_L2POPULATION'),
  }
} else {
  class { 'neutron::agents::ovs':
    bridge_mappings  => hiera_array('CONFIG_NEUTRON_OVS_BRIDGE_MAPPINGS'),
    enable_tunneling => true,
    tunnel_types     => ['gre'],
    local_ip         => $localip,
  }

  file { 'ovs_neutron_plugin.ini':
    path    => '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini',
    owner   => 'root',
    group   => 'neutron',
    before  => Service['ovs-cleanup-service'],
    require => Package['neutron-plugin-ovs'],
  }
}
