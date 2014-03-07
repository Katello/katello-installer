# Katello specific certs settings
class certs::katello {

  $katello_www_pub_dir            = '/var/www/html/pub'
  $candlepin_consumer_name        = "${$certs::default_ca_name}-consumer-${::fqdn}"
  $candlepin_consumer_summary     = "Subscription-manager consumer certificate for Katello instance ${::fqdn}"
  $candlepin_consumer_description = 'Consumer certificate and post installation script that configures rhsm.'

  file { $katello_www_pub_dir:
    ensure => directory,
    owner  => 'apache',
    group  => 'apache',
    mode   => '0755';
  } ->
  file { "${certs::ssl_build_dir}/rhsm-katello-reconfigure":
    content => template('certs/rhsm-katello-reconfigure.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
  } ~>
  exec { 'generate-candlepin-consumer-certificate':
    cwd       => $katello_www_pub_dir,
    command   => "katello-certs-gen-rpm --name '${candlepin_consumer_name}' --version 1.0 --release 1 --packager None --vendor None --group 'Applications/System' --summary '${candlepin_consumer_summary}' --description '${candlepin_consumer_description}' --requires subscription-manager --post ${certs::ssl_build_dir}/rhsm-katello-reconfigure /etc/rhsm/ca/candlepin-local.pem:644=${certs::ssl_build_dir}/${$certs::default_ca_name}.crt && /sbin/restorecon ./*rpm",
    path      => '/usr/bin:/bin',
    creates   => "${katello_www_pub_dir}/${candlepin_consumer_name}-1.0-1.noarch.rpm",
    logoutput => 'on_failure';
  } ~>
  file { "${katello_www_pub_dir}/${$certs::default_ca_name}-consumer-latest.noarch.rpm":
    ensure  => 'link',
    target  => "${katello_www_pub_dir}/${candlepin_consumer_name}-1.0-1.noarch.rpm",
  }

}
