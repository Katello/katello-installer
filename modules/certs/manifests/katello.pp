# Katello specific certs settings
class certs::katello (
  $hostname                      = $fqdn,
  $deployment_url                = undef,
  $rhsm_port                     = 443,
  $candlepin_cert_rpm_alias_filename = undef,
  ){

  $candlepin_cert_rpm_alias = $candlepin_cert_rpm_alias_filename ? {
    undef   => 'katello-ca-consumer-latest.noarch.rpm',
    default => $candlepin_cert_rpm_alias_filename,
  }

  $katello_www_pub_dir            = '/var/www/html/pub'
  $rhsm_ca_dir                    = '/etc/rhsm/ca'
  $katello_rhsm_setup_script      = 'katello-rhsm-consumer'
  $katello_rhsm_setup_script_location = "/usr/bin/${katello_rhsm_setup_script}"

  $candlepin_consumer_name        = "katello-ca-consumer-${::fqdn}"
  $candlepin_consumer_summary     = "Subscription-manager consumer certificate for Katello instance ${::fqdn}"
  $candlepin_consumer_description = 'Consumer certificate and post installation script that configures rhsm.'

  include ::trusted_ca
  trusted_ca::ca { 'katello_server-host-cert':
    source  => $certs::katello_server_ca_cert,
    require => File[$certs::katello_server_ca_cert],
  }

  file { $katello_www_pub_dir:
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0755',
  } ->
  # Placing the CA in the pub dir for trusting by a user in their browser
  file { "${katello_www_pub_dir}/${certs::server_ca_name}.crt":
    ensure  => file,
    source  => $certs::katello_server_ca_cert,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File[$certs::katello_server_ca_cert],
  } ~>
  certs::rhsm_reconfigure_script { "${katello_www_pub_dir}/${katello_rhsm_setup_script}":
    ca_cert        => $::certs::ca_cert,
    server_ca_cert => $::certs::katello_server_ca_cert,
  } ~>
  certs_bootstrap_rpm { $candlepin_consumer_name:
    dir              => $katello_www_pub_dir,
    summary          => $candlepin_consumer_summary,
    description      => $candlepin_consumer_description,
    # katello-default-ca is needed for the katello-agent to work properly
    # (especially in the custom certs scenario)
    files            => ["${katello_rhsm_setup_script_location}:755=${katello_www_pub_dir}/${katello_rhsm_setup_script}"],
    bootstrap_script => inline_template('/bin/bash <%= @katello_rhsm_setup_script_location %>'),
    postun_script    => 'test -f /etc/rhsm/rhsm.conf.kat-backup && command cp /etc/rhsm/rhsm.conf.kat-backup /etc/rhsm/rhsm.conf',
    alias            => $candlepin_cert_rpm_alias,
    subscribe        => $::certs::server_ca,
  }
}
