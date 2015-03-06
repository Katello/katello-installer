# Katello specific certs settings
class certs::katello (
  $hostname                      = $fqdn,
  $deployment_url                = undef,
  $rhsm_port                     = 443,
  $server_ca_name                = $::certs::server_ca_name,
  $candlepin_cert_rpm_alias_filename = undef
  ){

  $candlepin_cert_rpm_alias = $candlepin_cert_rpm_alias_filename ? {
    undef   => 'katello-ca-consumer-latest.noarch.rpm',
    default => $candlepin_cert_rpm_alias_filename,
  }

  $katello_www_pub_dir            = '/var/www/html/pub'
  $rhsm_ca_dir                    = '/etc/rhsm/ca'
  $candlepin_consumer_name        = "katello-ca-consumer-${::fqdn}"
  $candlepin_consumer_summary     = "Subscription-manager consumer certificate for Katello instance ${::fqdn}"
  $candlepin_consumer_description = 'Consumer certificate and post installation script that configures rhsm.'

  file { $katello_www_pub_dir:
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0755',
  } ->
  # Placing the CA in the pub dir for trusting by a user in their browser
  file { "${katello_www_pub_dir}/${certs::server_ca_name}.crt":
    ensure  => file,
    source  => "${certs::pki_dir}/certs/${certs::server_ca_name}.crt",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File["${certs::pki_dir}/certs/${certs::server_ca_name}.crt"],
  } ~>
  # We need to deliver the server_ca for yum and rhsm to trust the server
  # and the default_ca for goferd to trust the qpid
  certs_bootstrap_rpm { $candlepin_consumer_name:
    dir              => $katello_www_pub_dir,
    summary          => $candlepin_consumer_summary,
    description      => $candlepin_consumer_description,
    files            => ["${rhsm_ca_dir}/katello-server-ca.pem:644 =${certs::pki_dir}/certs/${certs::server_ca_name}.crt"],
    bootstrap_script => template('certs/rhsm-katello-reconfigure.erb'),
    alias            => $candlepin_cert_rpm_alias,
    subscribe        => $::certs::server_ca,
  }
}
