class apache::ssl (
    $hostname = $::certs::node_fqdn,
    $generate = $::certs::generate,
    $regenerate = $::certs::regenerate,
    $deploy   = $::certs::deploy,
    $ca       = $::certs::default_ca,
    $apache_ssl_cert = '/etc/pki/tls/certs/katello-node.crt',
    $apache_ssl_key = '/etc/pki/tls/private/katello-node.key'
  ) {

  cert { "${certs::node_fqdn}-ssl":
    hostname    => $certs::node_fqdn,
    ensure      => present,
    country     => $::certs::country,
    state       => $::certs::state,
    city        => $::certs::sity,
    org         => $::certs::org,
    org_unit    => $::certs::org_unit,
    expiration  => $::certs::expiration,
    ca          => $ca,
    generate    => $generate,
    regenerate    => $regenerate,
    deploy      => $deploy,
  }

  if $deploy {
    include apache

    pubkey { $apache_ssl_cert:
      ensure => present,
      cert => Cert["${certs::node_fqdn}-ssl"]
    } ~>
    privkey { $apache_ssl_key:
      ensure => present,
      cert => Cert["${certs::node_fqdn}-ssl"]
    }

    case $::osfamily {
      Debian:  {
        exec { 'enable-ssl':
          command => '/usr/sbin/a2enmod ssl',
          creates => '/etc/apache2/mods-enabled/ssl.load',
          notify  => Service['httpd'],
          require => Class['apache::install'],
        }
      }
      default: {
        package { 'mod_ssl':
          ensure  => present,
          require => Package['httpd'],
          notify  => Class['apache::service'],
        }
        file { "${apache::params::configdir}/ssl.conf":
          content => template("apache/ssl.conf.erb"),
          mode   => '0644',
          owner  => 'root',
          group  => 'root',
          require => [Pubkey[$apache_ssl_cert], Privkey[$apache_ssl_key]],
          notify => Exec['reload-apache'],
        }
        file {['/var/cache/mod_ssl', '/var/cache/mod_ssl/scache']:
          ensure => directory,
          owner  => 'apache',
          group  => 'root',
          mode   => '0700',
          notify => Exec['reload-apache'];
        }
      }
    }
  }

}
