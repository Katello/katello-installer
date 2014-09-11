# Configure the node
#
# === Parameters:
#
# $parent_fqdn::                    fqdn of the parent node. REQUIRED
#
# $certs_tar::                      path to a tar with certs for the node
#
# $pulp::                           should Pulp be configured on the node
#                                   type:boolean
#
# $pulp_master::                    whether the capsule should be identified as a pulp master server
#
# $pulp_admin_password::            passowrd for the Pulp admin user.It should be left blank so that random password is generated
#
# $pulp_oauth_effective_user::      User to be used for Pulp REST interaction
#
# $pulp_oauth_key::                 OAuth key to be used for Pulp REST interaction
#
# $pulp_oauth_secret::              OAuth secret to be used for Pulp REST interaction
#
# $foreman_proxy_port::             Port on which will foreman proxy listen
#                                   type:integer
#
# $puppet::                         Use puppet
#                                   type:boolean
#
# $puppetca::                       Use puppet ca
#                                   type:boolean
#
# $tftp::                           Use TFTP
#                                   type:boolean
#
# $tftp_syslinux_root::             Directory that hold syslinux files
#
# $tftp_syslinux_files::            Syslinux files to install on TFTP (copied from $tftp_syslinux_root)
#                                   type:array
#
# $tftp_root::                      TFTP root directory
#
# $tftp_dirs::                      Directories to be create in $tftp_root
#                                   type:array
#
# $tftp_servername::                Defines the TFTP server name to use, overrides the name in the subnet declaration
#
# $dhcp::                           Use DHCP
#                                   type:boolean
#
# $dhcp_managed::                   DHCP is managed by Foreman proxy
#                                   type:boolean
#
# $dhcp_interface::                 DHCP listen interface
#
# $dhcp_gateway::                   DHCP pool gateway
#
# $dhcp_range::                     Space-separated DHCP pool range
#
# $dhcp_nameservers::               DHCP nameservers
#
# $dhcp_vendor::                    DHCP vendor
#
# $dhcp_config::                    DHCP config file path
#
# $dhcp_leases::                    DHCP leases file
#
# $dhcp_key_name::                  DHCP key name
#
# $dhcp_key_secret::                DHCP password
#
# $dns::                            Use DNS
#                                   type:boolean
#
# $dns_managed::                    DNS is managed by Foreman proxy
#                                   type:boolean
#
# $dns_provider::                   DNS provider
#
# $dns_zone::                       DNS zone name
#
# $dns_reverse::                    DNS reverse zone name
#
# $dns_interface::                  DNS interface
#
# $dns_server::                     Address of DNS server to manage
#
# $dns_ttl::                        DNS default TTL override
#
# $dns_tsig_keytab::                Kerberos keytab for DNS updates using GSS-TSIG authentication
#
# $dns_tsig_principal::             Kerberos principal for DNS updates using GSS-TSIG authentication
#
# $dns_forwarders::                 DNS forwarders
#                                   type:array
#
# $virsh_network::                  Network for virsh DNS/DHCP provider
#
# $realm::                          Use realm management
#                                   type:boolean
#
# $realm_provider::                 Realm management provider
#
# $realm_keytab::                   Kerberos keytab path to authenticate realm updates
#
# $realm_principal::                Kerberos principal for realm updates
#
# $freeipa_remove_dns::             Remove DNS entries from FreeIPA when deleting hosts from realm
#                                   type:boolean
#
# $register_in_foreman::            Register proxy back in Foreman
#                                   type:boolean
#
# $foreman_oauth_effective_user::   User to be used for Foreman REST interaction
#
# $foreman_oauth_key::              OAuth key to be used for Foreman REST interaction
#
# $foreman_oauth_secret::           OAuth secret to be used for Foreman REST interaction
#
#
class capsule (
  $parent_fqdn                   = $capsule::params::parent_fqdn,
  $certs_tar                     = $capsule::params::certs_tar,
  $pulp                          = $capsule::params::pulp,
  $pulp_master                   = $capsule::params::pulp_master,
  $pulp_admin_password           = $capsule::params::pulp_admin_password,
  $pulp_oauth_effective_user     = $capsule::params::pulp_oauth_effective_user,
  $pulp_oauth_key                = $capsule::params::pulp_oauth_key,
  $pulp_oauth_secret             = $capsule::params::pulp_oauth_secret,

  $foreman_proxy_port            = $capsule::params::foreman_proxy_port,

  $puppet                        = $capsule::params::puppet,
  $puppetca                      = $capsule::params::puppetca,

  $tftp                          = $capsule::params::tftp,
  $tftp_syslinux_root            = $capsule::params::tftp_syslinux_root,
  $tftp_syslinux_files           = $capsule::params::tftp_syslinux_files,
  $tftp_root                     = $capsule::params::tftp_root,
  $tftp_dirs                     = $capsule::params::tftp_dirs,
  $tftp_servername               = $capsule::params::tftp_servername,

  $dhcp                          = $capsule::params::dhcp,
  $dhcp_managed                  = $capsule::params::dhcp_managed,
  $dhcp_interface                = $capsule::params::dhcp_interface,
  $dhcp_gateway                  = $capsule::params::dhcp_gateway,
  $dhcp_range                    = $capsule::params::dhcp_range,
  $dhcp_nameservers              = $capsule::params::dhcp_nameservers,
  $dhcp_vendor                   = $capsule::params::dhcp_vendor,
  $dhcp_config                   = $capsule::params::dhcp_config,
  $dhcp_leases                   = $capsule::params::dhcp_leases,
  $dhcp_key_name                 = $capsule::params::dhcp_key_name,
  $dhcp_key_secret               = $capsule::params::dhcp_key_secret,

  $dns                           = $capsule::params::dns,
  $dns_managed                   = $capsule::params::dns_managed,
  $dns_provider                  = $capsule::params::dns_provider,
  $dns_zone                      = $capsule::params::dns_zone,
  $dns_reverse                   = $capsule::params::dns_reverse,
  $dns_interface                 = $capsule::params::dns_interface,
  $dns_server                    = $capsule::params::dns_server,
  $dns_ttl                       = $capsule::params::dns_ttl,
  $dns_tsig_keytab               = $capsule::params::dns_tsig_keytab,
  $dns_tsig_principal            = $capsule::params::dns_tsig_principal,
  $dns_forwarders                = $capsule::params::dns_forwarders,

  $virsh_network                 = $capsule::params::virsh_network,

  $realm                         = $capsule::params::realm,
  $realm_provider                = $capsule::params::realm_provider,
  $realm_keytab                  = $capsule::params::realm_keytab,
  $realm_principal               = $capsule::params::realm_principal,
  $freeipa_remove_dns            = $capsule::params::freeipa_remove_dns,

  $register_in_foreman           = $capsule::params::register_in_foreman,
  $foreman_oauth_effective_user  = $capsule::params::foreman_oauth_effective_user,
  $foreman_oauth_key             = $capsule::params::foreman_oauth_key,
  $foreman_oauth_secret          = $capsule::params::foreman_oauth_secret

  ) inherits capsule::params {

  validate_present($capsule::parent_fqdn)

  if $pulp_master or $pulp {
    foreman_proxy::settings_file { 'pulp':
      template_path  => 'capsule/pulp.yml'
    }
    foreman_proxy::settings_file { 'pulpnode':
      template_path => 'capsule/pulpnode.yml'
    }
  }

  if $pulp {
    validate_pulp($pulp)
    validate_present($pulp_oauth_secret)
  }

  class { 'capsule::install': }

  $capsule_fqdn = $::fqdn
  $foreman_url = "https://${parent_fqdn}"

  if $register_in_foreman {
    validate_present($foreman_oauth_secret)
  }

  if $pulp {
    apache::vhost { 'capsule':
      servername      => $capsule_fqdn,
      port            => 80,
      priority        => '05',
      docroot         => '/var/www/html',
      options         => ['SymLinksIfOwnerMatch'],
      custom_fragment => template('capsule/_pulp_includes.erb'),
    }

    class { 'certs::apache':
      hostname => $capsule_fqdn
    }

    class { 'certs::qpid': } ~>
    class { 'pulp':
      default_password            => $pulp_admin_password,
      oauth_key                   => $pulp_oauth_key,
      oauth_secret                => $pulp_oauth_secret,
      qpid_ssl_cert_db            => $certs::nss_db_dir,
      qpid_ssl_cert_password_file => $certs::qpid::nss_db_password_file,
      messaging_ca_cert           => $certs::ca_cert,
      messaging_client_cert       => $certs::params::messaging_client_cert,
      messaging_url               => "ssl://${::fqdn}:5671"
    } ~>
    class { 'pulp::child':
      parent_fqdn          => $parent_fqdn,
      oauth_effective_user => $pulp_oauth_effective_user,
      oauth_key            => $pulp_oauth_key,
      oauth_secret         => $pulp_oauth_secret,
      server_ca_cert       => $certs::params::pulp_server_ca_cert,
    }

    class { 'certs::pulp_child':
      hostname => $capsule_fqdn,
      notify   => [ Class['pulp'], Class['pulp::child'] ],
    }
  }

  if $puppet {
    class { 'certs::puppet':
      hostname => $capsule_fqdn
    } ~>
    class { 'puppet':
      server                      => true,
      server_foreman_url          => $foreman_url,
      server_foreman_ssl_cert     => $::certs::puppet::client_cert,
      server_foreman_ssl_key      => $::certs::puppet::client_key,
      server_foreman_ssl_ca       => $::certs::puppet::ssl_ca_cert,
      server_storeconfigs_backend => false,
      server_dynamic_environments => true,
      server_environments_owner   => 'apache',
      server_config_version       => ''
    }
  }

  $foreman_proxy = $tftp or $dhcp or $dns or $puppet or $puppetca or $realm

  if $foreman_proxy {

    class { 'certs::foreman_proxy':
      hostname   => $capsule_fqdn,
      require    => Package['foreman-proxy'],
      before     => Service['foreman-proxy'],
    }

    class { 'foreman_proxy':
      custom_repo           => true,
      port                  => $foreman_proxy_port,
      puppetca              => $puppetca,
      ssl_cert              => $::certs::foreman_proxy::proxy_cert,
      ssl_key               => $::certs::foreman_proxy::proxy_key,
      ssl_ca                => $::certs::foreman_proxy::proxy_ca_cert,
      tftp                  => $tftp,
      tftp_syslinux_root    => $tftp_syslinux_root,
      tftp_syslinux_files   => $tftp_syslinux_files,
      tftp_root             => $tftp_root,
      tftp_dirs             => $tftp_dirs,
      tftp_servername       => $tftp_servername,
      dhcp                  => $dhcp,
      dhcp_interface        => $dhcp_interface,
      dhcp_gateway          => $dhcp_gateway,
      dhcp_range            => $dhcp_range,
      dhcp_nameservers      => $dhcp_nameservers,
      dhcp_vendor           => $dhcp_vendor,
      dhcp_config           => $dhcp_config,
      dhcp_leases           => $dhcp_leases,
      dhcp_key_name         => $dhcp_key_name,
      dhcp_key_secret       => $dhcp_key_secret,
      dns                   => $dns,
      dns_managed           => $dns_managed,
      dns_provider          => $dns_provider,
      dns_zone              => $dns_zone,
      dns_reverse           => $dns_reverse,
      dns_interface         => $dns_interface,
      dns_server            => $dns_server,
      dns_ttl               => $dns_ttl,
      dns_tsig_keytab       => $dns_tsig_keytab,
      dns_tsig_principal    => $dns_tsig_principal,
      dns_forwarders        => $dns_forwarders,
      virsh_network         => $virsh_network,
      realm                 => $realm,
      realm_provider        => $realm_provider,
      realm_keytab          => $realm_keytab,
      realm_principal       => $realm_principal,
      freeipa_remove_dns    => $freeipa_remove_dns,
      register_in_foreman   => $register_in_foreman,
      foreman_base_url      => $foreman_url,
      registered_proxy_url  => "https://${capsule_fqdn}:${capsule::foreman_proxy_port}",
      oauth_effective_user  => $foreman_oauth_effective_user,
      oauth_consumer_key    => $foreman_oauth_key,
      oauth_consumer_secret => $foreman_oauth_secret
    }
  }

  if $certs_tar {
    certs::tar_extract { $capsule::certs_tar: } -> Class['certs']

    if $pulp {
      Certs::Tar_extract[$certs_tar] -> Class['certs::apache']
      Certs::Tar_extract[$certs_tar] -> Class['certs::pulp_child']
    }

    if $puppet {
      Certs::Tar_extract[$certs_tar] -> Class['certs::puppet']
    }

    if $foreman_proxy {
      Certs::Tar_extract[$certs_tar] -> Class['certs::foreman_proxy']
    }

  }
}
