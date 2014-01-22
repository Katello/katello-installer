# Katello specific certs settings
class certs::katello {

  $ssl_build_path                 = '/root/ssl-build'
  $katello_www_pub_dir            = '/var/www/html/pub'
  $candlepin_cert_name            = 'candlepin-ca'
  $candlepin_consumer_name        = "${candlepin_cert_name}-consumer-${::fqdn}"
  $candlepin_consumer_summary     = "Subscription-manager consumer certificate for Katello instance ${::fqdn}"
  $candlepin_consumer_description = 'Consumer certificate and post installation script that configures rhsm.'

  file { $katello_www_pub_dir:
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0755';
  } ->
  file { $ssl_build_path:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0700';
  } ->
  file { "${ssl_build_path}/rhsm-katello-reconfigure":
    content => template('certs/rhsm-katello-reconfigure.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
  } ~>
  exec { 'generate-candlepin-consumer-certificate':
    cwd       => $katello_www_pub_dir,
    command   => "gen-rpm.sh --name '${candlepin_consumer_name}' --version 1.0 --release 1 --packager None --vendor None --group 'Applications/System' --summary '${candlepin_consumer_summary}' --description '${candlepin_consumer_description}' --requires subscription-manager --post ${ssl_build_path}/rhsm-katello-reconfigure /etc/rhsm/ca/candlepin-local.pem:644=${ssl_build_path}/${candlepin_cert_name}.crt && /sbin/restorecon ./*rpm",
    path      => '/usr/share/katello/certs:/usr/bin:/bin',
    creates   => "${katello_www_pub_dir}/${candlepin_consumer_name}-1.0-1.noarch.rpm",
    logoutput => 'on_failure';
  } ~>
  file { "${katello_www_pub_dir}/${candlepin_cert_name}-consumer-latest.noarch.rpm":
    ensure  => 'link',
    target  => "${katello_www_pub_dir}/${candlepin_consumer_name}-1.0-1.noarch.rpm",
  }
}
