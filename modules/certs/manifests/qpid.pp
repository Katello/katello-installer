# Handles Qpid cert configuration
class certs::qpid (

  $hostname = $::certs::node_fqdn,
  $generate = $::certs::generate,
  $regenerate = $::certs::regenerate,
  $deploy   = $::certs::deploy,
  $ca       = $::certs::default_ca

  ){

  Exec { logoutput => 'on_failure' }

  cert { "${::certs::qpid::hostname}-qpid-broker":
    ensure      => present,
    hostname    => $::certs::qpid::hostname,
    country     => $::certs::country,
    state       => $::certs::state,
    city        => $::certs::sity,
    org         => 'pulp',
    org_unit    => $::certs::org_unit,
    expiration  => $::certs::expiration,
    ca          => $ca,
    generate    => $generate,
    regenerate  => $regenerate,
    deploy      => $deploy,
  }

  if $deploy {

    $nss_db_password_file   = $certs::nss_db_password_file
    $ssl_pk12_password_file = $certs::ssl_pk12_password_file
    $qpid_cert_name         = 'qpid-broker'
    $client_cert            = "/etc/pki/katello/${qpid_cert_name}.crt"
    $client_key             = "/etc/pki/katello/${qpid_cert_name}.key"
    $pfx_path               = "/etc/pki/katello/${qpid_cert_name}.pfx"
    $nssdb_files            = ["${::certs::nss_db_dir}/cert8.db", "${::certs::nss_db_dir}/key3.db", "${::certs::nss_db_dir}/secmod.db"]

    File[$certs::pki_dir] ~>
    pubkey { $client_cert:
      cert => Cert["${::certs::qpid::hostname}-qpid-broker"]
    } ~>
    privkey { $client_key:
      cert => Cert["${::certs::qpid::hostname}-qpid-broker"]
    } ~>
    file { $client_key:
      ensure  => file,
      owner   => 'root',
      group   => $::certs::group,
      mode    => '0400',
    } ~>
    exec { 'generate-nss-password':
      command => "openssl rand -base64 24 > ${nss_db_password_file}",
      path    => '/usr/bin',
      creates => $nss_db_password_file
    } ->
    file { $nss_db_password_file:
      ensure  => file,
      owner   => 'root',
      group   => $::certs::group,
      mode    => '0640',
    } ~>
    exec { 'generate-pk12-password':
      path    => '/usr/bin',
      command => "openssl rand -base64 24 > ${ssl_pk12_password_file}",
      creates => $ssl_pk12_password_file
    } ~>
    file { $ssl_pk12_password_file:
      ensure  => file,
      owner   => 'root',
      group   => $::certs::group,
      mode    => '0600',
      require => Exec['generate-pk12-password']
    } ~>
    file { $::certs::nss_db_dir:
      ensure => directory,
      owner  => 'root',
      group  => $::certs::group,
      mode   => '0744',
    } ~>
    exec { 'create-nss-db':
      command => "certutil -N -d '${::certs::nss_db_dir}' -f '${nss_db_password_file}'",
      path    => '/usr/bin',
      creates => $nssdb_files,
    } ~>
    file { $nssdb_files:
      owner   => 'root',
      group   => $::certs::group,
      mode    => '0640',
    } ~>
    exec { 'add-broker-cert-to-nss-db':
      command     => "certutil -A -d '${::certs::nss_db_dir}' -n 'broker' -t ',,' -a -i '${client_cert}'",
      path        => '/usr/bin',
      refreshonly => true,
    } ~>
    exec { 'generate-pfx-for-nss-db':
      command     => "openssl pkcs12 -in ${client_cert} -inkey ${client_key} -export -out '${pfx_path}' -password 'file:${ssl_pk12_password_file}'",
      path        => '/usr/bin',
      refreshonly => true,
    } ~>
    exec { 'add-private-key-to-nss-db':
      command     => "pk12util -i '${pfx_path}' -d '${::certs::nss_db_dir}' -w '${ssl_pk12_password_file}' -k '${nss_db_password_file}'",
      path        => '/usr/bin',
      refreshonly => true,
    }

  }

}
